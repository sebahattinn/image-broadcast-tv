using ImageBroadcastApi.Data;
using ImageBroadcastApi.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using Microsoft.EntityFrameworkCore;


namespace ImageBroadcastApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ImagesController : ControllerBase
    {
        private readonly IWebHostEnvironment _env;
        private readonly DataContext _context;

        public ImagesController(IWebHostEnvironment env, DataContext context)
        {
            _env = env;
            _context = context;
        }

        [HttpPost("upload")]
        [Authorize]
        [DisableRequestSizeLimit]
        [Consumes("multipart/form-data")]
        [ApiExplorerSettings(IgnoreApi = true)]
        public async Task<IActionResult> Upload([FromForm] IFormFile file)
        {
            if (file == null || file.Length == 0)
                return BadRequest("Dosya seçilmedi");

            if (file.Length > 5 * 1024 * 1024)
                return BadRequest("Dosya boyutu 5MB'dan büyük olamaz.");

            var allowedExtensions = new[] { ".jpg", ".jpeg", ".png" };
            var extension = Path.GetExtension(file.FileName).ToLower();

            if (!allowedExtensions.Contains(extension))
                return BadRequest("Sadece jpg, jpeg veya png dosyaları yüklenebilir.");

            var uploadsFolder = Path.Combine(_env.WebRootPath, "uploads");
            if (!Directory.Exists(uploadsFolder))
                Directory.CreateDirectory(uploadsFolder);

            var fileName = Guid.NewGuid().ToString() + extension;
            var filePath = Path.Combine(uploadsFolder, fileName);

            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await file.CopyToAsync(stream);
            }

            // Güvenli userId alma
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier) ?? User.FindFirst("sub");
            if (!int.TryParse(userIdClaim?.Value, out var userId))
            {
                return Unauthorized("Kullanıcı kimliği geçersiz.");
            }

            var image = new ImageModel
            {
                FileName = fileName,
                FilePath = "/uploads/" + fileName,
                UploadedAt = DateTime.Now,
                UserId = userId
            };

            try
            {
                _context.Images.Add(image);
                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Veritabanına kayıt başarısız: {ex.Message}");
            }

            return Ok(image);
        }

        [HttpGet("my-images")]
        [Authorize]
        public async Task<ActionResult<IEnumerable<ImageModel>>> GetMyImages()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null) return Unauthorized();

            int userId = int.Parse(userIdClaim.Value);
            var images = await _context.Images
                .Where(i => i.UserId == userId)
                .OrderByDescending(i => i.UploadedAt)
                .ToListAsync();

            return Ok(images);
        }

        [HttpPost("broadcast/{imageId}")]
        [Authorize]
        public async Task<IActionResult> BroadcastImage(int imageId)
        {
            var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

            var image = await _context.Images.FirstOrDefaultAsync(i => i.Id == imageId && i.UserId == userId);
            if (image == null) return NotFound("Görsel bulunamadı");

            var allMyImages = _context.Images.Where(i => i.UserId == userId);
            foreach (var img in allMyImages) img.IsBroadcasted = false;

            image.IsBroadcasted = true;
            await _context.SaveChangesAsync();

            return Ok("Yayın başladı");
        }

        [HttpGet("broadcasted")]
        public IActionResult GetBroadcastedImage()
        {
            var image = _context.Images
                .Where(i => i.IsBroadcasted)
                .OrderByDescending(i => i.UploadedAt)
                .FirstOrDefault();

            if (image == null) return NotFound();
            return Ok(image);
        }









    }
}
