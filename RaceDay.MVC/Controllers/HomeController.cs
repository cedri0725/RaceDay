using Microsoft.AspNetCore.Mvc;

namespace RaceDay.MVC.Controllers
{
    public class HomeController : Controller
    {
        // Redirect to the Events page when someone visits the home page
        public IActionResult Index()
        {
            return RedirectToAction("Index", "Events");
        }

        public IActionResult Privacy()
        {
            return View();
        }
    }
}