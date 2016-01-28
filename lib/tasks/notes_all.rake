namespace :notes do
  desc "Enumerate all annotations"
  task 'all' do
    ENV['SOURCE_ANNOTATION_DIRECTORIES'] ||= 'spec'
    SourceAnnotationExtractor.enumerate "OPTIMIZE|FIXME|TODO|HACK", tag: true
  end
end
