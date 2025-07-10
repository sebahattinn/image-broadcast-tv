using System.ComponentModel.DataAnnotations.Schema;

namespace ImageBroadcastApi.Models
{
    public class ImageModel
    {
        public int Id { get; set; }

        public string FileName { get; set; } = string.Empty;
        public string FilePath { get; set; } = string.Empty;
        public DateTime UploadedAt { get; set; } = DateTime.Now; // 
        // Foreign Key
        public int UserId { get; set; } // NOT NULL
        public User User { get; set; } = null!;
        public bool IsBroadcasted { get; set; } = false;



    }
}
