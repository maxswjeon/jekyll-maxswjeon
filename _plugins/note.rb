#!/usr/bin/env ruby

# Note Plugin handles 
# - slug creation for notes
# - category management

module NotePlugin
  class NotePageGenerator < Jekyll::Generator
    attr_accessor :site

    safe true
    priority :normal

    def initialize(site)
      @site = site
    end

    def generate(site)
      @site = site

      site.collections['notes'].docs.each do |note|
        # Need to changes as lowercase
        slug = File.basename(note.path, ".*")
        slug = slug.gsub(/\s+/, '-')
        slug = slug.downcase
        note.data['slug'] = slug

        note.data['categories'] = note.relative_path.split('/')[1...-1]
      end
    end 
  end

  class CategoryPage < Jekyll::Page
    def initialize(site, base, category)

    end
  end
end