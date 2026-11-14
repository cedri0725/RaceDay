using System.ComponentModel.DataAnnotations;

namespace RaceDay.MVC.ViewModels
{
    public class RegisterViewModel
    {
        [Required, EmailAddress]
        public string Email { get; set; } = string.Empty;
        [Required, MinLength(6)]
        public string Password { get; set; } = string.Empty;
        [Required]
        public string Full_Name { get; set; } = string.Empty;
        public string? Phone_Number { get; set; }
        [Required]
        public string Role { get; set; } = "Participant";
    }
}