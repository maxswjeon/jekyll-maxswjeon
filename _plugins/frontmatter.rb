#!/usr/bin/env ruby

# frozen_string_literal: true

module FrontMatterPlugin
  FILENAME_BLACKLIST = %w(
    README
    LICENSE
    LICENCE
    COPYING
    CODE_OF_CONDUCT
    CONTRIBUTING
    ISSUE_TEMPLATE
    PULL_REQUEST_TEMPLATE
  ).freeze

  class Generator < Jekyll::Generator
    attr_accessor :site

    safe true
    priority :high

    CONFIG_KEY = "front_matter"
    ENABLED_KEY = "enabled"
    CLEANUP_KEY = "remove_originals"
    COLLECTIONS_KEY = "collections"

    def initialize(site)
      @site = site
    end

    def generate(site)
      @site = site
      return if disabled?

      collections.each do |collection|
        site.collections[collection].docs.concat(documents_to_add(collection))
        site.static_files -= static_files_to_remove(collection) if cleanup?
      end
    end

    private

    # An array of Jekyll::Documents to add, *excluding* blacklisted files
    def documents_to_add(collection_name)
      documents(collection_name).reject { |page| blacklisted?(page) }
    end

    # An array of Jekyll::StaticFile's, *excluding* blacklisted files
    def static_files_to_remove(collection_name)
      markdown_files(collection_name).reject { |page| blacklisted?(page) }
    end

    # An array of potential Jekyll::Documents to add, *including* blacklisted files
    def documents(collection_name)
      markdown_files(collection_name).map { |static_file| doc_from_static_file(static_file, collection_name) }
    end

    # An array of Jekyll::StaticFile's with a site-defined markdown extension
    def markdown_files(collection_name)
      site.static_files.select { |file| markdown_converter.matches(file.extname) && file.relative_path =~ /^_#{collection_name}/ }
    end

    # Given a Jekyll::StaticFile, returns the file as a Jekyll::Page
    def doc_from_static_file(static_file, collection_name)
      document = Jekyll::Document.new(static_file.path, site: site, collection: site.collections[collection_name])

      data = {
        'title' => File.basename(static_file.path, ".*"),
      }

      document.merge_data!(static_file.data)
      document.merge_data!(data)
      document.content = File.read(static_file.path)
      document
    end

    # Does the given Jekyll::Page match our filename blacklist?
    def blacklisted?(page)
      return false if whitelisted?(page)

      FILENAME_BLACKLIST.include?(page.basename.upcase)
    end

    def whitelisted?(page)
      return false unless site.config["include"].is_a? Array

      entry_filter.included?(page.relative_path)
    end

    def markdown_converter
      @markdown_converter ||= site.find_converter_instance(Jekyll::Converters::Markdown)
    end

    def entry_filter
      @entry_filter ||= Jekyll::EntryFilter.new(site)
    end

    # Option utilities
    def option(key)
      site.config[CONFIG_KEY] && site.config[CONFIG_KEY][key]
    end

    def disabled?
      option(ENABLED_KEY) == false
    end

    def cleanup?
      option(CLEANUP_KEY) == true
    end

    def collections
      option(COLLECTIONS_KEY) || []
    end
  end
end