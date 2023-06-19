#!/usr/bin/env ruby

Jekyll::Hooks.register :notes, :post_init do |note|
  commit_number = `git rev-list --count HEAD "#{ note.path }"`

  if commit_number.to_i > 1
    mtime = `git log -1 --pretty="%ad" --date=iso "#{ note.path }"`
    note.data['mtime'] = mtime
  end
end