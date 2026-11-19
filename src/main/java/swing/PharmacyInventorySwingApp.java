package swing;

import dao.MedicineDAO;
import model.Medicine;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableRowSorter;
import java.awt.*;
import java.util.List;

/**
 * Sushruta Pharmacy - Desktop Stock Audit & Verification Application
 * Implements the AJT Swing Technology requirement using Java Foundation Classes (Swing).
 * Reuses existing MedicineDAO and database connection.
 */
public class PharmacyInventorySwingApp extends JFrame {

    private final MedicineDAO medicineDAO;
    private DefaultTableModel tableModel;
    private JTable medicineTable;
    private TableRowSorter<DefaultTableModel> rowSorter;
    private JTextField searchField;
    private JLabel totalMedsLabel;
    private JLabel totalStockLabel;
    private JLabel lowStockLabel;
    private JLabel expiredLabel;

    public PharmacyInventorySwingApp() {
        this.medicineDAO = new MedicineDAO();
        initUI();
        loadMedicineData();
    }

    private void initUI() {
        setTitle("Sushruta Pharmacy - Desktop Inventory Audit (AJT Swing)");
        setSize(1000, 650);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLayout(new BorderLayout(10, 10));

        // 1. Header Banner
        JPanel headerPanel = new JPanel(new BorderLayout());
        headerPanel.setBackground(new Color(29, 78, 216)); // Medical Blue
        headerPanel.setBorder(new EmptyBorder(16, 20, 16, 20));

        JLabel titleLabel = new JLabel("Sushruta Pharmacy System - Desktop Inventory Audit Client");
        titleLabel.setFont(new Font("Segoe UI", Font.BOLD, 18));
        titleLabel.setForeground(Color.WHITE);

        JLabel subTitleLabel = new JLabel("AJT CSE Implementation: Java Swing Desktop Client with Live JDBC Connectivity");
        subTitleLabel.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        subTitleLabel.setForeground(new Color(219, 234, 254));

        headerPanel.add(titleLabel, BorderLayout.NORTH);
        headerPanel.add(subTitleLabel, BorderLayout.SOUTH);
        add(headerPanel, BorderLayout.NORTH);

        // 2. Metrics KPI Panel
        JPanel kpiPanel = new JPanel(new GridLayout(1, 4, 12, 0));
        kpiPanel.setBorder(new EmptyBorder(0, 16, 0, 16));

        totalMedsLabel = createMetricCard("Total Formulations", "0", new Color(30, 58, 138), kpiPanel);
        totalStockLabel = createMetricCard("Total Stock Units", "0", new Color(5, 150, 105), kpiPanel);
        lowStockLabel = createMetricCard("Low Stock Alerts", "0", new Color(217, 119, 6), kpiPanel);
        expiredLabel = createMetricCard("Expired Batches", "0", new Color(225, 29, 72), kpiPanel);

        // 3. Search & Control Toolbar
        JPanel controlPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 10));
        controlPanel.setBorder(new EmptyBorder(0, 10, 0, 10));

        JLabel searchLabel = new JLabel("Search Formulations:");
        searchLabel.setFont(new Font("Segoe UI", Font.BOLD, 12));
        searchField = new JTextField(22);
        searchField.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        searchField.setToolTipText("Filter live by brand, manufacturer, or batch");
        searchField.addCaretListener(e -> {
            String text = searchField.getText().trim();
            if (text.isEmpty()) {
                rowSorter.setRowFilter(null);
            } else {
                rowSorter.setRowFilter(RowFilter.regexFilter("(?i)" + text));
            }
        });

        JButton refreshBtn = new JButton("Refresh Data");
        refreshBtn.addActionListener(e -> loadMedicineData());

        JButton addStockBtn = new JButton("+ Quick Stock Intake");
        addStockBtn.setBackground(new Color(5, 150, 105));
        addStockBtn.setForeground(Color.WHITE);
        addStockBtn.setFocusPainted(false);
        addStockBtn.addActionListener(e -> handleStockAdjustment(true));

        JButton deductStockBtn = new JButton("- Dispense / Deduct");
        deductStockBtn.setBackground(new Color(225, 29, 72));
        deductStockBtn.setForeground(Color.WHITE);
        deductStockBtn.setFocusPainted(false);
        deductStockBtn.addActionListener(e -> handleStockAdjustment(false));

        controlPanel.add(searchLabel);
        controlPanel.add(searchField);
        controlPanel.add(refreshBtn);
        controlPanel.add(Box.createHorizontalStrut(20));
        controlPanel.add(addStockBtn);
        controlPanel.add(deductStockBtn);

        JPanel topContainer = new JPanel();
        topContainer.setLayout(new BoxLayout(topContainer, BoxLayout.Y_AXIS));
        topContainer.add(kpiPanel);
        topContainer.add(Box.createVerticalStrut(10));
        topContainer.add(controlPanel);

        add(topContainer, BorderLayout.CENTER);

        // 4. Data Table
        String[] columns = {"ID", "Medicine Name", "Category", "Manufacturer", "Batch No", "Cost", "Price", "Qty", "Expiry", "Status"};
        tableModel = new DefaultTableModel(columns, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };

        medicineTable = new JTable(tableModel);
        medicineTable.setRowHeight(26);
        medicineTable.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        medicineTable.getTableHeader().setFont(new Font("Segoe UI", Font.BOLD, 12));
        medicineTable.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);

        // Center align ID, Batch, Qty, Status
        DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
        centerRenderer.setHorizontalAlignment(JLabel.CENTER);
        medicineTable.getColumnModel().getColumn(0).setCellRenderer(centerRenderer);
        medicineTable.getColumnModel().getColumn(4).setCellRenderer(centerRenderer);
        medicineTable.getColumnModel().getColumn(7).setCellRenderer(centerRenderer);
        medicineTable.getColumnModel().getColumn(8).setCellRenderer(centerRenderer);
        medicineTable.getColumnModel().getColumn(9).setCellRenderer(centerRenderer);

        medicineTable.getColumnModel().getColumn(0).setPreferredWidth(45);
        medicineTable.getColumnModel().getColumn(1).setPreferredWidth(210);
        medicineTable.getColumnModel().getColumn(2).setPreferredWidth(140);
        medicineTable.getColumnModel().getColumn(3).setPreferredWidth(130);

        rowSorter = new TableRowSorter<>(tableModel);
        medicineTable.setRowSorter(rowSorter);

        JScrollPane scrollPane = new JScrollPane(medicineTable);
        scrollPane.setBorder(new EmptyBorder(0, 16, 16, 16));

        JPanel centerWrapper = new JPanel(new BorderLayout());
        centerWrapper.add(topContainer, BorderLayout.NORTH);
        centerWrapper.add(scrollPane, BorderLayout.CENTER);

        add(centerWrapper, BorderLayout.CENTER);
    }

    private JLabel createMetricCard(String title, String val, Color color, JPanel parent) {
        JPanel card = new JPanel(new BorderLayout());
        card.setBackground(new Color(248, 250, 252));
        card.setBorder(BorderFactory.createCompoundBorder(
            BorderFactory.createLineBorder(new Color(226, 232, 240), 1),
            new EmptyBorder(10, 12, 10, 12)
        ));

        JLabel titleLbl = new JLabel(title);
        titleLbl.setFont(new Font("Segoe UI", Font.PLAIN, 11));
        titleLbl.setForeground(new Color(100, 116, 139));

        JLabel valLbl = new JLabel(val);
        valLbl.setFont(new Font("Segoe UI", Font.BOLD, 18));
        valLbl.setForeground(color);

        card.add(titleLbl, BorderLayout.NORTH);
        card.add(valLbl, BorderLayout.SOUTH);
        parent.add(card);
        return valLbl;
    }

    public void loadMedicineData() {
        tableModel.setRowCount(0);
        try {
            List<Medicine> list = medicineDAO.getAllMedicines();
            int lowStock = 0;
            int expired = 0;
            int totalStock = 0;

            for (Medicine m : list) {
                String status = m.getStockStatus();
                if ("Low Stock".equals(status)) lowStock++;
                if ("Expired".equals(status)) expired++;
                totalStock += m.getQuantity();

                tableModel.addRow(new Object[]{
                    m.getMedicineId(),
                    m.getMedicineName(),
                    m.getCategory(),
                    m.getManufacturer(),
                    m.getBatchNumber(),
                    String.format("%.2f", m.getPurchasePrice()),
                    String.format("%.2f", m.getSellingPrice()),
                    m.getQuantity(),
                    m.getExpiryDate(),
                    status
                });
            }

            totalMedsLabel.setText(String.valueOf(list.size()));
            totalStockLabel.setText(String.valueOf(totalStock));
            lowStockLabel.setText(String.valueOf(lowStock));
            expiredLabel.setText(String.valueOf(expired));

        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, "Could not load medicine records: " + e.getMessage(), "Database Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void handleStockAdjustment(boolean isAddition) {
        int selectedRow = medicineTable.getSelectedRow();
        if (selectedRow == -1) {
            JOptionPane.showMessageDialog(this, "Please select a medicine row from the table first.", "Selection Required", JOptionPane.WARNING_MESSAGE);
            return;
        }

        int modelRow = medicineTable.convertRowIndexToModel(selectedRow);
        int medicineId = (Integer) tableModel.getValueAt(modelRow, 0);
        String medicineName = (String) tableModel.getValueAt(modelRow, 1);
        int currentQty = (Integer) tableModel.getValueAt(modelRow, 7);

        String prompt = isAddition 
            ? "Enter quantity to ADD to stock for [" + medicineName + "]:"
            : "Enter quantity to DEDUCT from stock for [" + medicineName + "] (Current: " + currentQty + "):";

        String input = JOptionPane.showInputDialog(this, prompt, isAddition ? "Add Stock" : "Deduct Stock", JOptionPane.PLAIN_MESSAGE);
        if (input == null || input.trim().isEmpty()) return;

        try {
            int amount = Integer.parseInt(input.trim());
            if (amount <= 0) {
                JOptionPane.showMessageDialog(this, "Adjustment amount must be a positive integer.", "Validation Error", JOptionPane.ERROR_MESSAGE);
                return;
            }

            if (!isAddition && amount > currentQty) {
                JOptionPane.showMessageDialog(this, "Cannot deduct " + amount + " units. Current stock is only " + currentQty + " units.", "Insufficient Stock", JOptionPane.WARNING_MESSAGE);
                return;
            }

            boolean ok = medicineDAO.updateStock(medicineId, amount, isAddition);
            if (ok) {
                JOptionPane.showMessageDialog(this, "Stock successfully updated for " + medicineName + "!", "Update Success", JOptionPane.INFORMATION_MESSAGE);
                loadMedicineData();
            } else {
                JOptionPane.showMessageDialog(this, "Database update failed.", "Error", JOptionPane.ERROR_MESSAGE);
            }
        } catch (NumberFormatException ex) {
            JOptionPane.showMessageDialog(this, "Please enter a valid numeric integer value.", "Format Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    public static void main(String[] args) {
        // Run with cross-platform or system look and feel
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception ignored) {}

        SwingUtilities.invokeLater(() -> {
            PharmacyInventorySwingApp app = new PharmacyInventorySwingApp();
            app.setVisible(true);
        });
    }
}
