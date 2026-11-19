package model;

import java.io.Serializable;
import java.sql.Date;
import java.time.LocalDate;

public class Medicine implements Serializable {
    private static final long serialVersionUID = 1L;

    private int medicineId;
    private String medicineName;
    private String category;
    private String manufacturer;
    private String batchNumber;
    private double purchasePrice;
    private double sellingPrice;
    private int quantity;
    private int minimumStock;
    private Date manufacturingDate;
    private Date expiryDate;
    private int supplierId;
    private String supplierName;
    private String description;

    public Medicine() {
    }

    public Medicine(int medicineId, String medicineName, String category, String manufacturer, 
                    String batchNumber, double purchasePrice, double sellingPrice, int quantity, 
                    int minimumStock, Date manufacturingDate, Date expiryDate, int supplierId, 
                    String description) {
        this.medicineId = medicineId;
        this.medicineName = medicineName;
        this.category = category;
        this.manufacturer = manufacturer;
        this.batchNumber = batchNumber;
        this.purchasePrice = purchasePrice;
        this.sellingPrice = sellingPrice;
        this.quantity = quantity;
        this.minimumStock = minimumStock;
        this.manufacturingDate = manufacturingDate;
        this.expiryDate = expiryDate;
        this.supplierId = supplierId;
        this.description = description;
    }

    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }

    public String getMedicineName() {
        return medicineName;
    }

    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }

    public String getBatchNumber() {
        return batchNumber;
    }

    public void setBatchNumber(String batchNumber) {
        this.batchNumber = batchNumber;
    }

    public double getPurchasePrice() {
        return purchasePrice;
    }

    public void setPurchasePrice(double purchasePrice) {
        this.purchasePrice = purchasePrice;
    }

    public double getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(double sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getMinimumStock() {
        return minimumStock;
    }

    public void setMinimumStock(int minimumStock) {
        this.minimumStock = minimumStock;
    }

    public Date getManufacturingDate() {
        return manufacturingDate;
    }

    public void setManufacturingDate(Date manufacturingDate) {
        this.manufacturingDate = manufacturingDate;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public int getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isExpired() {
        if (expiryDate == null) return false;
        Date today = Date.valueOf(LocalDate.now());
        return expiryDate.before(today);
    }

    public boolean isLowStock() {
        return !isExpired() && quantity > 0 && quantity <= minimumStock;
    }

    public boolean isOutOfStock() {
        return !isExpired() && quantity <= 0;
    }

    public String getStockStatus() {
        if (isExpired()) {
            return "Expired";
        } else if (quantity <= 0) {
            return "Out of Stock";
        } else if (quantity <= minimumStock) {
            return "Low Stock";
        } else {
            return "In Stock";
        }
    }
}
