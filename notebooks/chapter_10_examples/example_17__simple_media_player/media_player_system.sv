// media_player_system.sv
package media_player_pkg;

  // Base class for all media files
  virtual class MediaFile;
    protected string filename;
    protected int file_size;
    protected string format;
    
    function new(string fname, int fsize, string fmt);
      this.filename = fname;
      this.file_size = fsize;
      this.format = fmt;
    endfunction
    
    // Pure virtual function - must be implemented by derived classes
    pure virtual function void play();
    
    // Virtual function that can be overridden
    virtual function void display_info();
      $display("File: %s, Size: %0d KB, Format: %s", 
               filename, file_size, format);
    endfunction
    
    function string get_filename();
      return filename;
    endfunction
    
    function int get_file_size();
      return file_size;
    endfunction
    
  endclass

  // Audio file class
  class AudioFile extends MediaFile;
    protected int bitrate;
    protected int duration; // in seconds
    
    function new(string fname, int fsize, string fmt, int br, int dur);
      super.new(fname, fsize, fmt);
      this.bitrate = br;
      this.duration = dur;
    endfunction
    
    virtual function void play();
      $display("Playing audio: %s", filename);
      $display("   Bitrate: %0d kbps, Duration: %0d:%02d", 
               bitrate, duration/60, duration%60);
      $display("Audio streaming started...");
    endfunction
    
    virtual function void display_info();
      super.display_info();
      $display("   Audio Info - Bitrate: %0d kbps, Duration: %0d:%02d",
               bitrate, duration/60, duration%60);
    endfunction
    
  endclass

  // Video file class
  class VideoFile extends MediaFile;
    protected string resolution;
    protected int frame_rate;
    protected int duration; // in seconds
    
    function new(string fname, int fsize, string fmt, string res, 
                 int fps, int dur);
      super.new(fname, fsize, fmt);
      this.resolution = res;
      this.frame_rate = fps;
      this.duration = dur;
    endfunction
    
    virtual function void play();
      $display("Playing video: %s", filename);
      $display("   Resolution: %s, Frame Rate: %0d fps, Duration: %0d:%02d",
               resolution, frame_rate, duration/60, duration%60);
      $display("Video playback started...");
    endfunction
    
    virtual function void display_info();
      super.display_info();
      $display("   Video Info - Resolution: %s, FPS: %0d, Duration: %0d:%02d",
               resolution, frame_rate, duration/60, duration%60);
    endfunction
    
  endclass

  // Image file class
  class ImageFile extends MediaFile;
    protected string resolution;
    protected int color_depth;
    
    function new(string fname, int fsize, string fmt, string res, int depth);
      super.new(fname, fsize, fmt);
      this.resolution = res;
      this.color_depth = depth;
    endfunction
    
    virtual function void play();
      $display("Displaying image: %s", filename);
      $display("   Resolution: %s, Color Depth: %0d bits", 
               resolution, color_depth);
      $display("Image displayed on screen...");
    endfunction
    
    virtual function void display_info();
      super.display_info();
      $display("   Image Info - Resolution: %s, Color Depth: %0d bits",
               resolution, color_depth);
    endfunction
    
  endclass

  // Media player class that manages a collection of media files
  class MediaPlayer;
    protected MediaFile media_library[$];
    protected string player_name;
    
    function new(string name);
      this.player_name = name;
    endfunction
    
    function void add_media_file(MediaFile media);
      media_library.push_back(media);
      $display("Added '%s' to %s media library", 
               media.get_filename(), player_name);
    endfunction
    
    function void play_all_media();
      $display("\n=== %s: Playing All Media Files ===", player_name);
      foreach(media_library[i]) begin
        $display("\n[%0d] ", i+1);
        media_library[i].play();
      end
    endfunction
    
    function void display_library();
      $display("\n=== %s: Media Library ===", player_name);
      if(media_library.size() == 0) begin
        $display("Library is empty.");
        return;
      end
      
      foreach(media_library[i]) begin
        $display("\n[%0d] ", i+1);
        media_library[i].display_info();
      end
    endfunction
    
    function void play_media_by_index(int index);
      if(index >= 0 && index < media_library.size()) begin
        $display("\n=== Playing Media File %0d ===", index+1);
        media_library[index].play();
      end else begin
        $display("Invalid media index: %0d", index+1);
      end
    endfunction
    
    function int get_library_size();
      return media_library.size();
    endfunction
    
  endclass

endpackage

module media_player_system;
  import media_player_pkg::*;
  
  initial begin
    $display("=== Simple Media Player System ===");
    $display("Demonstrating polymorphism with different media types");
    $display();
  end
  
endmodule