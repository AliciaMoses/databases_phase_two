require_relative 'lib/database_connection'
require_relative 'lib/artist_repository'
require_relative 'lib/album_repository'


# We need to give the database name to the method `connect`.
DatabaseConnection.connect('music_library')

artist_repository = ArtistRepository.new
album_repository = AlbumRepository.new

# Print out each artist from the result set .
artist_repository.all.each do |artist|
  p artist
end

# Print out each artist from the result set .
album_repository.all.each do |album|
  p album
end


# get the album with id 2
album = album_repository.find(1)

p album.id
p album.title