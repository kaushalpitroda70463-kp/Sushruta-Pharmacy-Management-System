/**
 * Sushruta Pharmacy - Pharmacy Inventory Management System
 * Core UI Logic, Client-Side Filtering, Charting & Interactive State
 */

document.addEventListener('DOMContentLoaded', () => {
    // 1. Initialize Current Date in Topbar if element exists
    const dateDisplay = document.getElementById('currentDateDisplay');
    if (dateDisplay) {
        const options = { weekday: 'short', year: 'numeric', month: 'short', day: 'numeric' };
        dateDisplay.textContent = new Date().toLocaleDateString('en-US', options);
    }

    // 2. Initialize Interactive Search & Filters on Tables
    setupTableFilters();

    // 3. Render Reports Charts if on reports page
    if (document.getElementById('categoryChartCanvas') || document.getElementById('statusChartContainer')) {
        renderReportCharts();
    }
});

/**
 * Filter table rows dynamically based on Search input, Category dropdown, and Status dropdown
 */
function setupTableFilters() {
    const searchInput = document.getElementById('tableSearchInput');
    const categoryFilter = document.getElementById('tableCategoryFilter');
    const statusFilter = document.getElementById('tableStatusFilter');
    const table = document.querySelector('.custom-table');

    if (!table) return;

    function applyFilter() {
        const query = (searchInput ? searchInput.value : '').toLowerCase().trim();
        const selectedCategory = (categoryFilter ? categoryFilter.value : 'All');
        const selectedStatus = (statusFilter ? statusFilter.value : 'All');

        const rows = table.querySelectorAll('tbody tr');
        let visibleCount = 0;

        rows.forEach(row => {
            // Read dataset or text content
            const text = row.textContent.toLowerCase();
            const category = row.getAttribute('data-category') || '';
            const status = row.getAttribute('data-status') || '';

            const matchesQuery = !query || text.includes(query);
            const matchesCategory = selectedCategory === 'All' || category.toLowerCase() === selectedCategory.toLowerCase();
            const matchesStatus = selectedStatus === 'All' || status.toLowerCase() === selectedStatus.toLowerCase();

            if (matchesQuery && matchesCategory && matchesStatus) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });

        // Toggle empty state if no rows match
        const emptyRow = document.getElementById('noResultsRow');
        if (emptyRow) {
            emptyRow.style.display = (visibleCount === 0) ? '' : 'none';
        }
    }

    if (searchInput) searchInput.addEventListener('input', applyFilter);
    if (categoryFilter) categoryFilter.addEventListener('change', applyFilter);
    if (statusFilter) statusFilter.addEventListener('change', applyFilter);
}

/**
 * Manage Stock Quick Adjustment Modal
 */
function openStockModal(medicineId, medicineName, currentQty) {
    const dialog = document.getElementById('adjustStockModal');
    if (!dialog) return;

    document.getElementById('modalMedicineId').value = medicineId;
    document.getElementById('modalStockMedicineName').textContent = medicineName;
    document.getElementById('modalStockCurrentQty').textContent = currentQty;
    const title = document.getElementById('modalStockTitle');
    title.textContent = 'Add Medicine Stock';

    document.getElementById('stockAmountInput').value = '';
    dialog.showModal();
}

function closeStockModal() {
    const dialog = document.getElementById('adjustStockModal');
    if (dialog) dialog.close();
}

/**
 * Render Interactive Analytics & Charts on Stock Reports Page
 */
function renderReportCharts() {
    // 1. Stock Status Distribution Donut / Bar Chart
    const statusContainer = document.getElementById('statusChartContainer');
    if (statusContainer) {
        // Collect live counts from the cards or DOM
        const inStock = parseInt(document.getElementById('kpiInStock')?.textContent || '9');
        const lowStock = parseInt(document.getElementById('kpiLowStock')?.textContent || '4');
        const expired = parseInt(document.getElementById('kpiExpired')?.textContent || '3');
        const total = inStock + lowStock + expired || 1;

        const inStockPct = Math.round((inStock / total) * 100);
        const lowStockPct = Math.round((lowStock / total) * 100);
        const expiredPct = Math.round((expired / total) * 100);

        statusContainer.innerHTML = `
            <div class="bar-chart-container">
                <div class="bar-row">
                    <div class="bar-label-group">
                        <span>Optimal Stock (Good)</span>
                        <strong>${inStock} medicines (${inStockPct}%)</strong>
                    </div>
                    <div class="bar-track">
                        <div class="bar-fill green" style="width: ${inStockPct}%;"></div>
                    </div>
                </div>
                <div class="bar-row">
                    <div class="bar-label-group">
                        <span>Low Stock Alert (Reorder Needed)</span>
                        <strong>${lowStock} medicines (${lowStockPct}%)</strong>
                    </div>
                    <div class="bar-track">
                        <div class="bar-fill amber" style="width: ${lowStockPct}%;"></div>
                    </div>
                </div>
                <div class="bar-row">
                    <div class="bar-label-group">
                        <span>Expired (Quarantine / Discard)</span>
                        <strong>${expired} medicines (${expiredPct}%)</strong>
                    </div>
                    <div class="bar-track">
                        <div class="bar-fill rose" style="width: ${expiredPct}%;"></div>
                    </div>
                </div>
            </div>
        `;
    }

    // 2. HTML5 Canvas Category Breakdown Bar Chart
    const canvas = document.getElementById('categoryChartCanvas');
    if (canvas && canvas.getContext) {
        const ctx = canvas.getContext('2d');
        let data = [];

        const realDataEl = document.getElementById('realCategoryData');
        if (realDataEl && realDataEl.textContent.trim()) {
            try {
                data = JSON.parse(realDataEl.textContent.trim());
            } catch (e) {
                console.warn('Could not parse realCategoryData JSON', e);
            }
        }

        if (!data || data.length === 0) {
            data = [
                { label: 'Antibiotics', count: 4, color: '#1d4ed8' },
                { label: 'Cardio', count: 2, color: '#059669' },
                { label: 'Analgesics', count: 2, color: '#f59e0b' },
                { label: 'Antidiabetic', count: 2, color: '#8b5cf6' },
                { label: 'Antacid', count: 2, color: '#06b6d4' },
                { label: 'Respiratory', count: 2, color: '#ec4899' },
                { label: 'Other', count: 1, color: '#64748b' }
            ];
        }

        // Draw nice sharp bar chart
        const w = canvas.width = canvas.parentElement.clientWidth || 400;
        const h = canvas.height = 200;
        const maxCount = Math.max(...data.map(d => d.count), 1);
        const maxVal = Math.ceil(maxCount * 1.2);
        const barWidth = Math.max(16, Math.min(36, (w / data.length) - 16));
        const gap = Math.max(8, (w - (barWidth * data.length)) / (data.length + 1));

        ctx.clearRect(0, 0, w, h);
        
        // Draw grid lines
        ctx.strokeStyle = '#f1f5f9';
        ctx.lineWidth = 1;
        for (let i = 0; i <= 5; i++) {
            const y = h - 35 - (i * (h - 60) / 5);
            ctx.beginPath();
            ctx.moveTo(20, y);
            ctx.lineTo(w - 20, y);
            ctx.stroke();

            ctx.fillStyle = '#94a3b8';
            ctx.font = '10px Inter, sans-serif';
            ctx.fillText(i, 6, y + 3);
        }

        // Draw bars
        data.forEach((item, index) => {
            const x = gap + index * (barWidth + gap);
            const barH = (item.count / maxVal) * (h - 60);
            const y = h - 35 - barH;

            // Bar rounded top
            ctx.fillStyle = item.color;
            ctx.beginPath();
            ctx.roundRect(x, y, barWidth, barH, [4, 4, 0, 0]);
            ctx.fill();

            // Label
            ctx.fillStyle = '#475569';
            ctx.font = '10px Inter, sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText(item.label, x + barWidth / 2, h - 15);

            // Value
            ctx.fillStyle = '#0f172a';
            ctx.font = 'bold 11px Inter, sans-serif';
            ctx.fillText(item.count, x + barWidth / 2, y - 6);
        });
    }
}
