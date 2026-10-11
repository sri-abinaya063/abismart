/**
 * SmartShop Client Utilities
 */
document.addEventListener('DOMContentLoaded', () => {
    // Auto-dismiss alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
            if (bsAlert) {
                bsAlert.close();
            }
        }, 5000);
    });

    // Quantity Increment / Decrement handlers
    document.querySelectorAll('.btn-quantity-decrease').forEach(btn => {
        btn.addEventListener('click', (e) => {
            const input = e.target.closest('.input-group').querySelector('.quantity-input');
            let val = parseInt(input.value) || 1;
            if (val > 1) {
                input.value = val - 1;
                triggerFormSubmit(input);
            }
        });
    });

    document.querySelectorAll('.btn-quantity-increase').forEach(btn => {
        btn.addEventListener('click', (e) => {
            const input = e.target.closest('.input-group').querySelector('.quantity-input');
            let val = parseInt(input.value) || 1;
            const max = parseInt(input.getAttribute('max')) || 999;
            if (val < max) {
                input.value = val + 1;
                triggerFormSubmit(input);
            }
        });
    });

    function triggerFormSubmit(input) {
        const form = input.closest('form');
        if (form && form.classList.contains('auto-update-form')) {
            form.submit();
        }
    }
});
