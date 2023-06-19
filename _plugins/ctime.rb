#!/usr/bin/env ruby

# File movement is considered as a creation

Jekyll::Hooks.register :notes, :post_init do |note|
  commit_number = `git rev-list --count HEAD "#{ note.path }"`

  if commit_number.to_i > 1
    ctime = `git log --diff-filter=A --pretty="%ad" --date=iso "#{ note.path }" | tail -1`
    note.data['ctime'] = ctime

    # Set date to ctime if date is not set
    note.data['date'] = ctime unless note.data['date']
  end
end