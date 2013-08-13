# upgrading from rails 1 to 2.2 
# original script by technoweenie 
# additions taken from other sources including: 
# http://rubythis.blogspot.com/2006/12/ruby-on-rails-deprecations-part-2.html
# http://mentalized.net/journal/2007/03/13/rails_20_deprecations/
# http://www.slashdotdash.net/2007/12/03/rails-2-upgrade-notes/
# http://www.akuaku.org/archives/2008/04/upgrading_to_ra.shtml
# Does not include checks for Rails 2.3 changes.

namespace :rails2 do
  desc "Checks your app and gently warns you if you are using deprecated code."
  task :deprecated => :environment do
    deprecated = {
      '@params'    => 'Use params[] instead',
      '@session'   => 'Use session[] instead',
      '@flash'     => 'Use flash[] instead',
      '@request'   => 'Use request[] instead',
      '@env' => 'Use env[] instead',
      'find_all[^_]'   => 'Use find(:all) instead',
      'find_first[^_]' => 'Use find(:first) instead',
      'render_.*\b' => 'Use render (:partial, :text, etc.) instead of render_*',
      'component'  => 'Use of components are frowned upon',
      'paginate'   => 'The default paginator is slow. Writing your own may be faster',
      'start_form_tag'   => 'Use form_for instead',
      'end_form_tag'   => 'Use form_for instead',
      ':post => true'   => 'Use :method => :post instead',
      'auto_complete' => 'is now a plugin',
      'acts_as_.*\b' => 'many of the built-in acts_as features are now plugins; check them',
      'builder' => 'is now a plugin',
      'in_place_editor' => 'is now a plugin',      
      'redirect_to_url' => 'use redirect_to instead',
      ':dependent => true' =>  'use :dependent => :destroy',
      ':exclusively_dependent' => 'use :dependent => :delete_all',
      'push_with_attributes' => 'use has_many :through',
      'count_by' => 'use count(column_name, options)',
      'human_attribute_name' => 'use .humanize',
      'img_tag' => 'make sure image tags include extensions',
      'radio_button_tag' => 'behavior has changed with Rails 2; check docs', 
      'TzTime' => 'use built-in Active record Time.zone and drop tztime plugins'
    }

    deprecated.each do |key, warning|
      puts '--> ' + key
      output = `cd '#{File.expand_path('app', RAILS_ROOT)}' && grep -n --exclude=*.svn* -r '#{key}' *`
      unless output =~ /^$/
        puts "  !! " + warning + " !!"
        puts '  ' + '.' * (warning.length + 6)
        puts output
      else
        puts "  Clean! Cheers for you!"
      end
      puts      
    end
    
    puts 'Some configuration items to be aware of:'
    puts
    puts 'Check your config environments for: config.action_view.cache_template_extensions, and remove.'
    puts 'ActionView::Base is now ActionView::Template'
    
  end

    desc 'Fix rxml'
    task :fix_rxml do      
      Dir.glob('app/views/**/[^_]*.xml.builder').each do |file|
        puts "svn rename #{file} #{file.gsub(/\.xml.builder$/, '.rxml')}"
#        system "svn rename #{file} #{file.gsub(/\.xml.builder$/, '.rxml')}"
      end
    end

    desc 'Renames (with GIT) all .rhtml views to .html.erb, .rjs to .js.rjs, .rxml to .xml.builder, and .haml to .html.haml'
    task :git_rename do
      
      Dir.glob('app/views/**/*.rhtml').each do |file|
        puts `svnn rename #{file} #{file.gsub(/\.rhtml$/, '.html.erb')}`
      end

      Dir.glob('app/views/**/[^_]*.rxml').each do |file|
        puts `svnn rename #{file} #{file.gsub(/\.rxml$/, '.xml.builder')}`
      end

      Dir.glob('app/views/**/[^_]*.rjs').each do |file|
        puts `svnn rename #{file} #{file.gsub(/\.rjs$/, '.js.rjs')}`
      end
      Dir.glob('app/views/**/[^_]*.haml').each do |file|
        puts `svnn rename #{file} #{file.gsub(/\.haml$/, '.html.haml')}`
      end
    end

end
