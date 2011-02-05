atom_feed :language => 'de-AT' do |feed|
  feed.title "Schandflecken"
  feed.updated @updated

  @incident_reports.each do |item|
    next if item.updated_at.blank?

    feed.entry(item) do |entry|
      entry.url incident_report_url(item)
      entry.title "Incident at #{item.longitude} #{item.latitude}"
      entry.content item.description, :type => 'text'

      # the strftime is needed to work with Google Reader.
      entry.updated(item.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 

      entry.author do |author|
        author.name item.author.nil? ? "anonymous" : item.author.email
      end
    end
  end
end