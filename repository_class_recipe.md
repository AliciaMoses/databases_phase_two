# Albums Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `albums`*

```
# EXAMPLE
Table: albums
Columns:
id | title | release_year
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- (RESTART IDENTITY resets the primary key)
TRUNCATE TABLE artists RESTART IDENTITY; 
TRUNCATE TABLE albums RESTART IDENTITY; 

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.
INSERT INTO artists (name, genre) VALUES ('Radiohead', 'Alternative rock');

INSERT INTO albums (title, release_year, artist_id) VALUES ('Kid A', '2000', '1');
INSERT INTO albums (title, release_year, artist_id) VALUES ('In Rainbows', '2007', '1');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby

# Table name: albums
# Model class
# (in lib/album.rb)
class Album
    attr_accessor :id, :title, :release_year, :artist_id 
end

# Repository class
# (in lib/album_repository.rb)
class AlbumRepository
    def all 
    # Executes the SQL query:
    # SELECT id, title, release_year FROM albums;
    end 

    # select a single album record given its argument (a number)
    def find(id)
      # Executes the SQL;
      # SELECT id, title, release_year, artist_id FROM albums WHERE id = $1;

      # Returns a single Album object
    end
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: albums
# Model class
# (in lib/album.rb)
class Album
  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :release_year
end
# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# album = Album.new
# album.name = ''
# album.name
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: albums
# Repository class
# (in lib/album_repository.rb)
class AlbumRepository
  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, release_year FROM albums;
    # Returns an array of album objects.
  end
  def find(id)
    # Executes the SQL query:
    #   SELECT id, title, release_year, artist_id FROM albums WHERE id = $1;
    # Returns a single album object with the corresponding id
  end
  
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES
# 1
# Get all albums
repo = AlbumRepository.new
albums = repo.all
albums.length # => 2 
albums.first.title # => 'Kid A'
albums.first.release_year # => '2000'
album.first.artist_id # => '1'

# 2
# Get all albums when there are no albums in the database

repo = AlbumRepository.new
albums = repo.all # => []


# Get a single album ('Kid A')

repo = AlbumRepository.new
album = repo.find(1)
album.title  # => 'Kid A'
album.release_year  # => '2000'
album.artist_id # => '1'


# Get a single album ('In Rainbows')

repo = AlbumRepository.new
album = repo.find(2)
album.title  # => 'In Rainbows'
album.release_year  # => '2007'
album.artist_id # => '1'
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE
# file: spec/album_repository_spec.rb
def reset_albums_table
  seed_sql = File.read('spec/seeds_albums.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end
describe AlbumRepository do
  before(:each) do 
    reset_albums_table
  end
  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._