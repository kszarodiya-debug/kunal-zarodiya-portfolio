const menuToggle = document.querySelector('.menu-toggle');
const nav = document.querySelector('.primary-nav');
const cursorGlow = document.querySelector('.cursor-glow');
const toast = document.querySelector('.toast');
let toastTimer;

const showToast = (message) => {
  if (!toast) return;
  toast.textContent = message;
  toast.classList.add('is-visible');
  window.clearTimeout(toastTimer);
  toastTimer = window.setTimeout(() => toast.classList.remove('is-visible'), 4200);
};

const closeMenu = () => {
  nav?.classList.remove('is-open');
  menuToggle?.setAttribute('aria-expanded', 'false');
};

const toggleMenu = () => {
  const isOpen = nav.classList.toggle('is-open');
  menuToggle.setAttribute('aria-expanded', String(isOpen));
};

menuToggle?.addEventListener('click', toggleMenu);
menuToggle?.addEventListener('keydown', (event) => {
  if (event.key === 'Enter' || event.key === ' ') {
    event.preventDefault();
    toggleMenu();
  }
});

nav?.querySelectorAll('a').forEach((link) => link.addEventListener('click', closeMenu));

document.addEventListener('keydown', (event) => {
  if (event.key === 'Escape') {
    closeMenu();
    toast?.classList.remove('is-visible');
  }
});

document.addEventListener('click', (event) => {
  if (!nav?.classList.contains('is-open')) return;
  if (!nav.contains(event.target) && !menuToggle?.contains(event.target)) closeMenu();
});

document.querySelectorAll('[data-placeholder-action]').forEach((action) => {
  action.addEventListener('click', (event) => {
    event.preventDefault();
    const item = action.dataset.placeholderAction;
    showToast(`Placeholder action: add ${item} in index.html before publishing.`);
  });
});

const contactForm = document.querySelector('#contact-form');
const formStatus = document.querySelector('#form-status');
contactForm?.addEventListener('submit', (event) => {
  event.preventDefault();
  if (!contactForm.checkValidity()) {
    contactForm.reportValidity();
    if (formStatus) formStatus.textContent = 'Please complete all required fields.';
    return;
  }
  if (formStatus) formStatus.textContent = 'Message validated locally. Connect an email service or backend to send it.';
  showToast('Message validated locally — no data was sent.');
  contactForm.reset();
});

const revealObserver = 'IntersectionObserver' in window
  ? new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
          revealObserver.unobserve(entry.target);
        }
      });
    }, { threshold: 0.12 })
  : null;

document.querySelectorAll('.reveal').forEach((element) => {
  if (revealObserver) revealObserver.observe(element);
  else element.classList.add('is-visible');
});

if (cursorGlow && window.matchMedia('(pointer: fine)').matches) {
  window.addEventListener('pointermove', (event) => {
    cursorGlow.style.left = `${event.clientX}px`;
    cursorGlow.style.top = `${event.clientY}px`;
  }, { passive: true });
}

const year = document.querySelector('#year');
if (year) year.textContent = new Date().getFullYear();
