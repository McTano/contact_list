require_relative 'lib/contact'
require_relative 'lib/interface'

include Interface

case ARGV.first
when 'list', 'all' then Interface.list
when 'new', 'create' then Interface.create
when 'show', 'find' then Interface.show(ARGV[1])
when 'search' then Interface.search(ARGV[1])
when 'update' then Interface.update(ARGV[1])
when 'destroy', 'delete' then Interface.destroy(ARGV[1])
else Interface.print_menu
end