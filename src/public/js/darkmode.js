/**
 * Dark Mode Manager
 */

function initDarkMode() {
    // Leer preferencia guardada, o preferencia del sistema operativo.
    // localStorage puede lanzar (modo privado estricto, política de la
    // organización que lo bloquea) — sin el try/catch, esa excepción
    // rompía la carga de la página entera antes de que corriera nada más.
    let saved = null;
    try { saved = localStorage.getItem('darkMode'); } catch (e) { /* se cae a la preferencia del sistema */ }
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    const isDark = saved !== null ? saved === 'true' : prefersDark;

    if (isDark) {
        document.documentElement.classList.add('dark');
    }

    updateToggleUI(isDark);
}

function toggleDarkMode() {
    const isDark = document.documentElement.classList.toggle('dark');
    try { localStorage.setItem('darkMode', isDark); } catch (e) { /* el modo cambia igual, solo no se recuerda para la próxima visita */ }
    updateToggleUI(isDark);
}

// Dos instancias del mismo control (desktop y mobile, ver index.html) —
// mismo criterio que textsize.js con sus botones A-/A+: actualizar las
// dos a la vez para que el ícono/título de la versión mobile no se quede
// congelado en luna cuando el tema cambia desde cualquiera de las dos.
function updateToggleUI(isDark) {
    document.querySelectorAll('#dark-mode-toggle, #dark-mode-toggle-mobile').forEach((toggleBtn) => {
        if (isDark) {
            toggleBtn.innerHTML = '<i class="fas fa-sun text-yellow-400"></i>';
            toggleBtn.title = t('nav.switch_to_light');
            toggleBtn.setAttribute('aria-label', t('nav.switch_to_light'));
        } else {
            toggleBtn.innerHTML = '<i class="fas fa-moon text-gray-600"></i>';
            toggleBtn.title = t('nav.switch_to_dark');
            toggleBtn.setAttribute('aria-label', t('nav.switch_to_dark'));
        }
    });
}

window.initDarkMode = initDarkMode;
window.toggleDarkMode = toggleDarkMode;