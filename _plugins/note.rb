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

      categories = []

      notes = site.collections['notes'].docs
      notes.each do |note|
        # Need to changes as lowercase
        slug = File.basename(note.path, ".*")
        slug = slug.gsub(/\s+/, '-')
        slug = slug.downcase
        note.data['slug'] = slug

        note.data['categories'] = note.relative_path.split('/')[1...-1]

        category = []
        for i in 0..note.data['categories'].length-1
          category.push(note.data['categories'][i])
          if !categories.include?(category.join('/'))
            categories.push(category.join('/'))
          end
        end
      end

      site.data['categories'] = categories

      categories.each do |category|
        site.pages << CategoryPage.new(site, site.source, category, categories, notes, false)
      end

      site.pages << CategoryPage.new(site, site.source, "", categories, notes, true)
    end 
  end

  class CategoryPage < Jekyll::Page
    def initialize(site, base, category, categories, notes, root)
      @site = site
      @base = base

      if root
        @dir = 'categories'
      else 
        @dir = 'categories/' + category
      end

      @basename = 'index'
      @ext = '.html'
      @name = 'index.html'

      category_path = category.split('/')
      category_name = category_path.pop()
      category_path = category_path.join('/')

      category_notes = []
      notes.each do |note|
        note_category = note.data['categories'].join('/')
        if category == note_category
          category_notes.push(note.data['title'])
        end
      end

      category_categories = []
      categories.each do |cat|
        if category == ''
          if cat.count('/') == 0
            category_categories.push(cat)
          end
        elsif cat != category && cat.include?(category) && cat.sub(category + '/', '').count('/') == 0
          category_categories.push(cat.sub(category + '/', ''))
        end
      end

      @data = {
        'layout' => 'category',
        'category_path' => category_path,
        'category_name' => category_name,
        'category_notes' => category_notes,
        'category_categories' => category_categories
      }
    end
  end
end