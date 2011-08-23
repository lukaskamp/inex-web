module InexUtils

  def self.included(mod)
    fail "This module is not intended to be included"
  end

  def self.strip_cs_chars(src, also_kill_weirdos = true)
    accented_chars  = 'éěřťýúůíóášďžčňÉĚŘŤÝÚŮÍÓÁŠĎŽČŇ'
    ascii_chars     = 'eertyuuioasdzcnEERTYUUIOASDZCN'
    dest = src.dup

    (0...accented_chars.chars.g_length).each do |i|
        dest.gsub!(accented_chars.chars[i..i], ascii_chars[i..i])
    end

    if also_kill_weirdos
      dest.gsub!(/[^A-Za-z0-9]/, " ")
    end

    dest
  end

  def self.string_for_url(src)
    strip_cs_chars(src).gsub(/[^A-Za-z0-9]/,"-")
  end

  def self.test_env?
    RAILS_ENV == "test"
  end

  def self.public_root
    if InexUtils::test_env?
      RAILS_ROOT + "/test/fixtures"
    else
      RAILS_ROOT + "/public"
    end
  end

  def self.article_image_list
    Dir.chdir("#{public_root}#{par("article_image_root")}") do
      Dir.glob("**/*.{jpg,png,gif}", File::FNM_CASEFOLD).sort
    end
  end

  def self.layout_image_list
    Dir.chdir("#{public_root}#{par("layout_image_root")}") do
#      Dir.glob("**/*.jpg", File::FNM_CASEFOLD).sort
      Dir.glob("**/*").reject{|x| File::directory?(x)}.sort
    end
  end

  def self.attachment_list
    Dir.chdir("#{public_root}#{par("attachment_root")}") do
      Dir.glob("**/*").reject{|x| File::directory?(x)}.sort
    end
  end

  def self.ltv_attachment_list
    Dir.chdir("#{public_root}#{par("ltv_attachment_root")}") do
      Dir.glob("**/*").reject{|x| File::directory?(x)}.sort
#      Dir["*"].reject{|x| File::directory?(x)}.sort
    end
  end

  def self.article_thumbnail_filename(filename,w,h)
    "#{par("article_image_root")}/.#{w}x#{h}/#{filename}"
  end

  def self.article_thumbnail!(filename,w,h)
    require 'ftools'

    original_filename = "#{InexUtils::public_root}#{par("article_image_root")}/#{filename}"
    thumbnail_filename = article_thumbnail_filename(filename,w,h)

    unless File.exists? "#{InexUtils::public_root}#{thumbnail_filename}"
      thumb = Thumber::make_thumbnail(original_filename, w, h)
      File.makedirs(File::dirname("#{InexUtils::public_root}#{thumbnail_filename}"))
      thumb.write("#{InexUtils::public_root}#{thumbnail_filename}")
    end
  end

  def self.article_thumbnail?(filename,w,h)
    File.exists? "#{InexUtils::public_root}#{InexUtils::article_thumbnail_filename(filename,w,h)}"
  end

  def self.clear_article_thumbnails
    Dir.chdir("#{public_root}#{par("article_image_root")}") do
      Dir.glob("*",File::FNM_DOTMATCH).sort.each do |dir_name|
        if File::directory?(dir_name) and dir_name=~/^\.\d+x\d+$/
          Dir.glob("#{dir_name}/**/*").each do |file_name|
            File::delete(file_name) unless File::directory?(file_name)
          end
        end
      end
    end
  end

  private

  # hack
  def self.par(key)
    Parameter.get_value(key)
  end

end
