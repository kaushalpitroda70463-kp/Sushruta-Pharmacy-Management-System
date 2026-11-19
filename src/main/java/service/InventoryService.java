package service;

import dao.MedicineDAO;
import dao.SupplierDAO;
import model.Medicine;
import model.Supplier;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/** Spring-managed application service used by the web layer. */
@Service
public class InventoryService {
    private final MedicineDAO medicineDAO;
    private final SupplierDAO supplierDAO;

    @Autowired
    public InventoryService(MedicineDAO medicineDAO, SupplierDAO supplierDAO) {
        this.medicineDAO = medicineDAO;
        this.supplierDAO = supplierDAO;
    }

    public List<Medicine> getMedicines() { return medicineDAO.getAllMedicines(); }
    public List<Supplier> getSuppliers() { return supplierDAO.getAllSuppliers(); }
    public Medicine getMedicine(int id) { return medicineDAO.getMedicineById(id); }
    public boolean adjustStock(int id, int amount, boolean add) { return medicineDAO.updateStock(id, amount, add); }
}
