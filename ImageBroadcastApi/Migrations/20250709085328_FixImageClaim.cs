using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ImageBroadcastApi.Migrations
{
    /// <inheritdoc />
    public partial class FixImageClaim : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsBroadcasted",
                table: "Images",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsBroadcasted",
                table: "Images");
        }
    }
}
