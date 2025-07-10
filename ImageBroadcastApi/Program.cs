using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using ImageBroadcastApi.Data;

var builder = WebApplication.CreateBuilder(args);

// EF DbContext
builder.Services.AddDbContext<DataContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// ✅ CORS Ayarı (Flutter Android emülatörü için)
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFlutterApp", policy =>
    {
        policy.WithOrigins("http://10.0.2.2:5125") // Flutter emülatörü localhost'u
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// ✅ Kestrel ayarları (Yalnızca HTTP dinleme)
builder.WebHost.ConfigureKestrel(serverOptions =>
{
    serverOptions.ListenAnyIP(5125); // Sadece HTTP, HTTPS tamamen kaldırıldı
});

// JWT Auth
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(builder.Configuration["AppSettings:Token"]!)),
            ValidateIssuer = false,
            ValidateAudience = false
        };
    });

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// ✅ Middleware sırası
// ⚠️ HTTPS yönlendirme kaldırıldı (app.UseHttpsRedirection(); satırı silindi)
app.UseCors("AllowFlutterApp");
app.UseAuthentication();
app.UseStaticFiles();
app.UseAuthorization();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.MapControllers();
app.Run();
