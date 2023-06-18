#!/usr/bin/env ruby

module NotePlugin
  class NotePageGenerator < Jekyll::Generator
    attr_accessor :site

    safe true

    def initialize(site)
      @site = site
    end

    def generate(site)
      @site = site

      # Handle notes without front matter
      site.collections['notes'].docs.concat(notes)
      site.static_files -= markdown_files      

      site.collections['notes'].docs.each do |note|
        # Need to changes as lowercase
        slug = File.basename(note.path, ".*")
        slug = slug.gsub(/\s+/, '-')
        slug = slug.downcase
        note.data['slug'] = slug

        site.pages << NotePage.new(site, site.source, note)
      end
    end 

    # From jekyll-optional-front-matter plugin, for supporting collection pages
    def notes
      markdown_files.map { |static_file| docs_from_static_file(static_file) }
    end

    def markdown_files
      site.static_files.select { |file| markdown_converter.matches(file.extname) && file.relative_path =~ /notes\/.*\.md/ }
    end

    def docs_from_static_file(static_file)
      document = Jekyll::Document.new(static_file.path, site: site, collection: site.collections['notes'])

      data = {
        'title' => File.basename(static_file.path, ".*"),
      }

      document.merge_data!(static_file.data)
      document.merge_data!(data)
      document.content = File.read(static_file.path)
      document
    end

    def markdown_converter
      @markdown_converter ||= site.find_converter_instance(Jekyll::Converters::Markdown)
    end
  end

  class NotePage < Jekyll::Page
    def initialize(site, base, note)
      @site = site
      @base = base
      @dir = File.dirname(note.relative_path)
      @name = "index.html"

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'page.html')

      note.data.each_pair do |key, value|
        self.data[key] = value
      end

      self.data['permalink'] = "/notes/#{note.data['slug']}/"
    end 
  end
end