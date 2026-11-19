package dao;

import model.Medicine;
import model.Supplier;
import model.User;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Assume;
import org.junit.Test;

import java.sql.Connection;
import java.util.List;

public class DAOTest {

    @BeforeClass
    public static void requireIsolatedDatabase() {
        String testUrl = System.getenv("TEST_DB_URL");
        if (testUrl == null || testUrl.trim().isEmpty()) {
            testUrl = System.getProperty("test.db.url");
        }
        Assume.assumeTrue("Integration tests require TEST_DB_URL or -Dtest.db.url; refusing to touch the application database", 
                testUrl != null && !testUrl.trim().isEmpty());
        System.setProperty("db.url", testUrl.trim());
        String testUser = System.getenv("TEST_DB_USER");
        if (testUser == null) testUser = System.getProperty("test.db.user");
        if (testUser != null) System.setProperty("db.user", testUser);
        String testPassword = System.getenv("TEST_DB_PASSWORD");
        if (testPassword == null) testPassword = System.getProperty("test.db.password");
        if (testPassword != null) System.setProperty("db.password", testPassword);
    }

    @Test
    public void testDatabaseConnection() throws Exception {
        try (Connection conn = DBConnection.getConnection()) {
            Assert.assertNotNull("Connection should not be null", conn);
            Assert.assertFalse("Connection should be open", conn.isClosed());
        }
    }

    @Test
    public void testUserAuthenticationPharmacist() {
        UserDAO userDAO = new UserDAO();
        User user = userDAO.authenticate("pharmacist", "pharmacist123", "Pharmacist");
        Assert.assertNotNull("Pharmacist user should authenticate successfully against database", user);
        Assert.assertEquals("pharmacist", user.getUsername());
        Assert.assertTrue("User role should be Pharmacist", user.isPharmacist());
    }

    @Test
    public void testUserAuthenticationManager() {
        UserDAO userDAO = new UserDAO();
        User user = userDAO.authenticate("manager", "manager123", "Inventory Manager");
        Assert.assertNotNull("Manager user should authenticate successfully against database", user);
        Assert.assertEquals("manager", user.getUsername());
        Assert.assertTrue("User role should be Inventory Manager", user.isInventoryManager());
    }

    @Test
    public void testUserAuthenticationInvalid() {
        UserDAO userDAO = new UserDAO();
        User user = userDAO.authenticate("unknown_user", "bad_pass", "Pharmacist");
        Assert.assertNull("Invalid user should return null", user);
    }

    @Test
    public void testGetAllMedicines() {
        MedicineDAO medicineDAO = new MedicineDAO();
        List<Medicine> medicines = medicineDAO.getAllMedicines();
        Assert.assertNotNull("Medicines list should not be null", medicines);
        Assert.assertTrue("Medicines list should contain records from database", medicines.size() >= 15);
    }

    @Test
    public void testLowStockAndExpiredQueries() {
        MedicineDAO medicineDAO = new MedicineDAO();
        List<Medicine> lowStock = medicineDAO.getLowStockMedicines();
        Assert.assertNotNull(lowStock);

        List<Medicine> expired = medicineDAO.getExpiredMedicines();
        Assert.assertNotNull(expired);
    }

    @Test
    public void testGetAllSuppliers() {
        SupplierDAO supplierDAO = new SupplierDAO();
        List<Supplier> suppliers = supplierDAO.getAllSuppliers();
        Assert.assertNotNull("Suppliers list should not be null", suppliers);
        Assert.assertTrue("Suppliers list should have records", suppliers.size() >= 5);
    }

    @Test
    public void testGetCategoryDistribution() {
        MedicineDAO medicineDAO = new MedicineDAO();
        java.util.Map<String, Integer> catMap = medicineDAO.getCategoryDistribution();
        Assert.assertNotNull("Category map should not be null", catMap);
        Assert.assertFalse("Category map should contain grouped categories", catMap.isEmpty());
    }

    @Test
    public void testStockUpdateIsolated() {
        MedicineDAO medicineDAO = new MedicineDAO();
        // Create an isolated temporary test medicine so real inventory data is never modified
        Medicine tempMed = new Medicine();
        tempMed.setMedicineName("__TEST_ISOLATED_MED__");
        tempMed.setCategory("Antibiotics");
        tempMed.setManufacturer("Test Labs");
        tempMed.setBatchNumber("TEST-BATCH-99");
        tempMed.setPurchasePrice(10.0);
        tempMed.setSellingPrice(15.0);
        tempMed.setQuantity(50);
        tempMed.setMinimumStock(10);
        tempMed.setManufacturingDate(java.sql.Date.valueOf("2026-01-01"));
        tempMed.setExpiryDate(java.sql.Date.valueOf("2028-01-01"));
        tempMed.setDescription("Transient test formulation for isolated unit tests.");

        boolean added = medicineDAO.addMedicine(tempMed);
        Assert.assertTrue("Transient test medicine should be created", added);
        int testId = tempMed.getMedicineId();
        Assert.assertTrue("Generated ID should be positive", testId > 0);

        try {
            // Add 10 units
            boolean stockAdded = medicineDAO.updateStock(testId, 10, true);
            Assert.assertTrue("Stock add should return true", stockAdded);
            Medicine updatedAfterAdd = medicineDAO.getMedicineById(testId);
            Assert.assertEquals(60, updatedAfterAdd.getQuantity());

            // Deduct 20 units
            boolean stockDeducted = medicineDAO.updateStock(testId, 20, false);
            Assert.assertTrue("Stock deduct should return true", stockDeducted);
            Medicine updatedAfterDeduct = medicineDAO.getMedicineById(testId);
            Assert.assertEquals(40, updatedAfterDeduct.getQuantity());
        } finally {
            // Strictly clean up test record to guarantee pristine database state
            medicineDAO.deleteMedicine(testId);
            Medicine deletedMed = medicineDAO.getMedicineById(testId);
            Assert.assertNull("Transient test medicine must be cleanly purged", deletedMed);
        }
    }

    @Test
    public void testSwingAppInitialization() {
        if (!java.awt.GraphicsEnvironment.isHeadless()) {
            swing.PharmacyInventorySwingApp app = new swing.PharmacyInventorySwingApp();
            Assert.assertNotNull("Swing App instance should not be null", app);
            app.dispose();
        }
    }
}
