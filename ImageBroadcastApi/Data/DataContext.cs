using ImageBroadcastApi.Models;
using Microsoft.EntityFrameworkCore;

namespace ImageBroadcastApi.Data
{
    public class DataContext : DbContext
    {
    
    public DataContext(DbContextOptions<DataContext> options) : base(options) { }
    public DbSet<User> Users { get; set; }
    public DbSet<ImageModel> Images { get; set; }




    }
}
