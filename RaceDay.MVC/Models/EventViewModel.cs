namespace RaceDay.MVC.Models
{
    public class EventViewModel
    {
        public int Event_ID { get; set; }
        public string Event_Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public DateTime Event_Date { get; set; }
        public string Location { get; set; } = string.Empty;
        public int Max_Capacity { get; set; }
        public string Organiser_Name { get; set; } = string.Empty;
    }
}