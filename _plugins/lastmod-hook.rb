#!/usr/bin/env ruby

Jekyll::Hooks.register :notes, :note_init do |note|
  commit_number = `git rev-list --count HEAD "#{ note.path }"`

  if commit_number.to_i > 1
    lastmod_date = `git log -1 --pretty="%ad" --date=iso "#{ note.path }`
    post.data['mtime'] = lastmod_date
  end
end