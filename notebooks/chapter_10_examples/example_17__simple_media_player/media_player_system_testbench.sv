// media_player_system_testbench.sv
module media_player_testbench;
  import media_player_pkg::*;
  
  // Instantiate the design under test
  media_player_system MEDIA_PLAYER_INSTANCE();
  
  initial begin
    // Dump waves for debugging
    $dumpfile("media_player_testbench.vcd");
    $dumpvars(0, media_player_testbench);
    
    // Test the media player functionality
    test_media_player();
    
    #10; // Wait a bit before finishing
    $display("\nTestbench completed successfully!");
    $finish;
  end
  
  // Task to test media player functionality
  task test_media_player();
    // Create media player instance
    MediaPlayer my_player;
    
    // Create different types of media files
    AudioFile song1, song2;
    VideoFile movie1, movie2;
    ImageFile photo1, photo2;
    
    // Array to demonstrate polymorphism
    MediaFile mixed_media[$];
    
    $display("=== Creating Media Player ===");
    my_player = new("MyAwesome Player");
    
    $display("\n=== Creating Media Files ===");
    // Create audio files
    song1 = new("favorite_song.mp3", 4500, "MP3", 320, 215);
    song2 = new("classical_piece.flac", 35000, "FLAC", 1411, 180);
    
    // Create video files  
    movie1 = new("action_movie.mp4", 2100000, "MP4", "1920x1080", 24, 7200);
    movie2 = new("documentary.mkv", 1800000, "MKV", "1280x720", 30, 5400);
    
    // Create image files
    photo1 = new("vacation_photo.jpg", 2500, "JPEG", "4032x3024", 24);
    photo2 = new("wallpaper.png", 8000, "PNG", "3840x2160", 32);
    
    $display("\n=== Adding Media to Player ===");
    // Add media files to player
    my_player.add_media_file(song1);
    my_player.add_media_file(movie1);
    my_player.add_media_file(photo1);
    my_player.add_media_file(song2);
    my_player.add_media_file(movie2);
    my_player.add_media_file(photo2);
    
    // Display library contents
    my_player.display_library();
    
    $display("\n=== Testing Individual Media Playback ===");
    // Play specific media files
    my_player.play_media_by_index(0); // Audio
    my_player.play_media_by_index(1); // Video
    my_player.play_media_by_index(2); // Image
    
    // Play all media files (demonstrates polymorphism)
    my_player.play_all_media();
    
    $display("\n=== Demonstrating Polymorphism with Mixed Array ===");
    // Create mixed array of different media types
    mixed_media.push_back(song1);
    mixed_media.push_back(movie1);
    mixed_media.push_back(photo1);
    mixed_media.push_back(song2);
    
    $display("Playing mixed media types using polymorphic calls:");
    foreach(mixed_media[i]) begin
      $display("\n--- Mixed Media Item %0d ---", i+1);
      mixed_media[i].display_info();
      mixed_media[i].play();
    end
    
    $display("\n=== Testing Error Handling ===");
    // Test invalid index
    my_player.play_media_by_index(99);
    
    $display("\n=== Media Player Demo Complete ===");
    $display("Library contains %0d media files", my_player.get_library_size());
    $display("Demonstrated polymorphic behavior with different media types");
    
  endtask
  
endmodule