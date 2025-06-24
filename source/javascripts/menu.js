const btn = document.getElementById("mobile-menu-toggle");
const menu = document.getElementById("mobile-menu");
const servicesBtn = document.getElementById("mobile-services-toggle");
const servicesMenu = document.getElementById("mobile-services-menu");
const servicesChevron = document.getElementById("mobile-services-chevron");

// Toggle main mobile menu
btn.addEventListener("click", () => {
  menu.classList.toggle("hidden");
});

// Toggle Services submenu
if (servicesBtn && servicesMenu && servicesChevron) {
  servicesBtn.addEventListener("click", () => {
    servicesMenu.classList.toggle("hidden");
    servicesChevron.classList.toggle("rotate-180");
  });
}

// Close the mobile menu when any in-page anchor (#…) is clicked
document.querySelectorAll('#mobile-menu a[href^="/#"]').forEach((anchor) =>
  anchor.addEventListener("click", () => {
    menu.classList.add("hidden");
    // Optionally also collapse the services submenu:
    if (!servicesMenu.classList.contains("hidden")) {
      servicesMenu.classList.add("hidden");
      servicesChevron.classList.remove("rotate-180");
    }
  }),
);
