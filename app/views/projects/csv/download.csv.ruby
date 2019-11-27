CSV.generate(encoding: 'SJIS', headers: I18n.t('csv.projects'), write_headers: true) do |csv|
  @projects&.each { |p| csv << p.csv_columns }
end
