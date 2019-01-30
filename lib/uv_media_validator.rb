require "uv_media_validator/version"
require "uv_media_validator/tw_image"
require "uv_media_validator/tw_agif"
require "uv_media_validator/tw_video"
require "uv_media_validator/fb_image"
require "uv_media_validator/fb_video"

module UvMediaValidator
  class Error < StandardError; end

  def self.get_tw_validator(path, sync_flag: true)
    image_size = ImageSize.path(path)
    if image_size.format.nil?
      return TwVideo.new(path, sync_flag: sync_flag)
    elsif image_size.format != :gif
      return TwImage.new(path, info: image_size)
    end
    gif_info = GifInfo::analyze_file(path)
    if gif_info.images_count > 1
      return TwAgif.new(path, info: gif_info)
    else
      return TwImage.new(path, info: image_size)
    end
  end

  def self.get_fb_validator(path, sync_flag: true)
    image_size = ImageSize.path(path)
    if image_size.format.nil?
      return FbVideo.new(path, sync_flag: sync_flag)
    else
      return FbImage.new(path, info: image_size)
    end
  end
end