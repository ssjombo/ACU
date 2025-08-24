#!/bin/bash

echo "=== Spring Boot GraphQL Server Demo (with Many-to-Many Genres and Reviews) ==="
echo

# Check if the server is running
echo "1. Checking if the server is running..."
if curl -s http://localhost:8081/graphql > /dev/null; then
    echo "✅ Server is running on http://localhost:8081"
else
    echo "❌ Server is not running. Please start it with: mvn spring-boot:run"
    echo "   Then run this script again."
    exit 1
fi

echo
echo "2. Testing Authentication..."

# Login to get JWT token
echo "🔐 Logging in with default credentials..."
LOGIN_RESPONSE=$(curl -s -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "username": "313@acu.com",
    "password": "123456"
  }' \
  http://localhost:8081/auth/login)

# Extract token from response
TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
    echo "❌ Login failed. Please check if the server is running and the default user exists."
    echo "Response: $LOGIN_RESPONSE"
    exit 1
fi

echo "✅ Login successful! JWT token obtained."
echo "Token: ${TOKEN:0:50}..."

echo
echo "3. Testing GraphQL Queries..."

# Test 1: Query book-1 (The Lucky Country) - Full fields
echo
echo "📚 Querying 'The Lucky Country' (book-1) - Full fields:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { bookById(id: \"book-1\") { id name pageCount author { id firstName lastName } } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 1.1: Field Selection - Only name and genre
echo "📚 Field Selection - Only name and genre:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { bookById(id: \"book-1\") { name genre } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 1.2: Field Selection - name, genre, and author (nested selection)
echo "📚 Field Selection - name, genre, and author (nested selection):"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { bookById(id: \"book-1\") { name genre author { firstName lastName } } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 1.3: Field Selection - Minimal fields (only name)
echo "📚 Field Selection - Minimal fields (only name):"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { bookById(id: \"book-1\") { name } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 2: Query book-2 (The Magic Pudding)
echo "📚 Querying 'The Magic Pudding' (book-2):"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { bookById(id: \"book-2\") { id name pageCount author { id firstName lastName } } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 3: Query non-existent book
echo "❌ Querying non-existent book:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { bookById(id: \"non-existent\") { id name pageCount author { id firstName lastName } } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 4: Query with variables
echo "🔧 Querying with variables:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query GetBook($id: ID!) { bookById(id: $id) { id name pageCount author { firstName lastName } } }",
    "variables": { "id": "book-1" }
  }' \
  http://localhost:8081/graphql

echo
echo

echo "4. Testing GraphQL Pagination and Filtering..."

# Test 11: Query books with pagination
echo
echo "📖 Querying books with pagination (first 3) - Full fields:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { books(first: 3) { edges { cursor node { id name pageCount genre author { id firstName lastName } } } pageInfo { hasNextPage hasPreviousPage startCursor endCursor } totalCount } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 11.1: Field Selection with pagination - Only specific fields
echo "📖 Field Selection with pagination - Only name, genre, and author:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { books(first: 3) { edges { cursor node { name genre author { firstName lastName } } } pageInfo { hasNextPage } totalCount } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 12: Query books with cursor pagination
echo "📖 Querying books with cursor pagination:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { books(first: 2, after: \"Ym9vay0x\") { edges { cursor node { id name pageCount genre author { id firstName lastName } } } pageInfo { hasNextPage hasPreviousPage startCursor endCursor } totalCount } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 13: Query books with search filter
echo "🔍 Querying books with search filter (search: 'Lucky'):"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { books(first: 5, search: \"Lucky\") { edges { cursor node { id name pageCount genre author { id firstName lastName } } } pageInfo { hasNextPage hasPreviousPage startCursor endCursor } totalCount } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 14: Query books with genre filter
echo "📚 Querying books with genre filter (genre: 'Non-Fiction'):"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { books(first: 5, genre: \"Non-Fiction\") { edges { cursor node { id name pageCount genre author { id firstName lastName } } } pageInfo { hasNextPage hasPreviousPage startCursor endCursor } totalCount } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 15: Query books with search and genre filter
echo "🔍📚 Querying books with search and genre filter (search: 'Lucky', genre: 'Non-Fiction'):"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { books(first: 5, search: \"Lucky\", genre: \"Non-Fiction\") { edges { cursor node { id name pageCount genre author { id firstName lastName } } } pageInfo { hasNextPage hasPreviousPage startCursor endCursor } totalCount } }"
  }' \
  http://localhost:8081/graphql

echo
echo

echo "6. Testing GraphQL Sorting..."

# Test 16: Query books ordered by name
echo "📚 Querying books ordered by name:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { books(first: 5, orderBy: NAME) { edges { cursor node { id name pageCount genre author { id firstName lastName } } } pageInfo { hasNextPage hasPreviousPage startCursor endCursor } totalCount } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 17: Query books ordered by page count
echo "📚 Querying books ordered by page count:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { books(first: 5, orderBy: PAGE_COUNT) { edges { cursor node { id name pageCount genre author { id firstName lastName } } } pageInfo { hasNextPage hasPreviousPage startCursor endCursor } totalCount } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 18: Query books ordered by genre
echo "📚 Querying books ordered by genre:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { books(first: 5, orderBy: GENRE) { edges { cursor node { id name pageCount genre author { id firstName lastName } } } pageInfo { hasNextPage hasPreviousPage startCursor endCursor } totalCount } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 19: Query books with search and ordered by name
echo "🔍📚 Querying books with search and ordered by name (search: 'Lucky', orderBy: NAME):"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { books(first: 5, search: \"Lucky\", orderBy: NAME) { edges { cursor node { id name pageCount genre author { id firstName lastName } } } pageInfo { hasNextPage hasPreviousPage startCursor endCursor } totalCount } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 20: Query books with genre filter and ordered by page count
echo "📚 Querying books with genre filter and ordered by page count (genre: 'Non-Fiction', orderBy: PAGE_COUNT):"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { books(first: 5, genre: \"Non-Fiction\", orderBy: PAGE_COUNT) { edges { cursor node { id name pageCount genre author { id firstName lastName } } } pageInfo { hasNextPage hasPreviousPage startCursor endCursor } totalCount } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 21: Query books with search, genre filter, and ordered by genre
echo "🔍📚 Querying books with search, genre filter, and ordered by genre (search: 'Lucky', genre: 'Non-Fiction', orderBy: GENRE):"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { books(first: 5, search: \"Lucky\", genre: \"Non-Fiction\", orderBy: GENRE) { edges { cursor node { id name pageCount genre author { id firstName lastName } } } pageInfo { hasNextPage hasPreviousPage startCursor endCursor } totalCount } }"
  }' \
  http://localhost:8081/graphql

echo
echo

echo "7. Testing Genre Queries..."

# Test 22: Query all genres
echo
echo "📚 Querying all genres:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { genres { id name description } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 23: Query genre by ID
echo "📚 Querying genre by ID (genre-1):"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { genreById(id: \"genre-1\") { id name description books { id name } } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 24: Query books by genre
echo "📚 Querying books by genre (genre-2 - Non-Fiction):"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { booksByGenre(genreId: \"genre-2\", first: 5) { edges { cursor node { id name pageCount author { firstName lastName } } } pageInfo { hasNextPage } totalCount } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 25: Query book with genres
echo "📚 Querying book with genres (book-1):"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { bookById(id: \"book-1\") { id name pageCount genre genres { id name description } author { firstName lastName } } }"
  }' \
  http://localhost:8081/graphql

echo
echo

echo "8. Testing GraphQL Mutations..."

# Test 5: Create a new author
echo
echo "👤 Creating a new author:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "mutation { createAuthor(input: { firstName: \"Jane\", lastName: \"Austen\" }) { id firstName lastName } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 6: Create a new book
echo "📖 Creating a new book:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "mutation { createBook(input: { name: \"Pride and Prejudice\", pageCount: 432, authorId: \"author-1\", genre: \"Romance\" }) { id name pageCount genre author { id firstName lastName } } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 7: Update a book
echo "✏️ Updating book-1:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "mutation { updateBook(id: \"book-1\", input: { name: \"The Lucky Country - Updated Edition\", pageCount: 320, genre: \"History\" }) { id name pageCount genre author { id firstName lastName } } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 8: Delete a book
echo "🗑️ Deleting book-2:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "mutation { deleteBook(id: \"book-2\") }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 9: Try to delete non-existent book
echo "❌ Trying to delete non-existent book:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "mutation { deleteBook(id: \"non-existent\") }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 10: Verify book-1 was updated
echo "✅ Verifying book-1 was updated:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { bookById(id: \"book-1\") { id name pageCount genre author { id firstName lastName } } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 26: Create a new genre
echo "📚 Creating a new genre:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "mutation { createGenre(input: { name: \"Young Adult\", description: \"Literature written for young adults\" }) { id name description } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 27: Add genre to book
echo "📚 Adding genre to book:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "mutation { addGenreToBook(bookId: \"book-1\", genreId: \"genre-1\") { id name genres { id name } } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 28: Query book with multiple genres
echo "📚 Querying book with multiple genres:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { bookById(id: \"book-1\") { id name genres { id name description } } }"
  }' \
  http://localhost:8081/graphql

echo
echo

echo "9. Testing Field-Level Security (Reviews Visibility)..."
echo
echo "🔒 Field-Level Security: Only ADMIN users can see book reviews"
echo "   - ADMIN users: Can see reviews field"
echo "   - Non-admin users: Reviews field returns null (hidden)"

# Test 29: Query book with reviews as ADMIN user (should show reviews)
echo
echo "👑 ADMIN User - Querying book-1 with reviews (should show reviews):"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { bookById(id: \"book-1\") { id name reviews { id rating comment } } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 29.1: Query book with reviews as USER role (should hide reviews)
echo "👤 USER Role - Querying book-1 with reviews (should hide reviews):"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { bookById(id: \"book-1\") { id name reviews { id rating comment } } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 29.2: Query books list with reviews as ADMIN user
echo "👑 ADMIN User - Querying books list with reviews (should show reviews):"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { books(first: 1) { edges { node { id name reviews { id rating comment } } } } }"
  }' \
  http://localhost:8081/graphql

echo
echo

echo "10. Testing Review Functionality..."

# Test 30: Query reviews for a book
echo
echo "⭐ Querying reviews for book-1:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { reviewsByBook(bookId: \"book-1\") { id bookId userId rating comment createdAt } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 31: Query book with reviews and ratings
echo "⭐ Querying book-1 with reviews and ratings:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { bookById(id: \"book-1\") { id name averageRating reviewCount reviews { id rating comment createdAt } } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 32: Create a new review
echo "⭐ Creating a new review for book-1:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "mutation { createReview(input: { bookId: \"book-1\", rating: 5, comment: \"Amazing book about Australia! Highly recommended.\" }) { id bookId userId rating comment createdAt } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 33: Update a review
echo "⭐ Updating a review:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "mutation { updateReview(id: \"review-1\", input: { rating: 4, comment: \"Updated comment: Great historical perspective!\" }) { id rating comment } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 34: Query reviews by user
echo "⭐ Querying reviews by user:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { reviewsByUser(userId: \"1\") { id bookId rating comment createdAt } }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 35: Delete a review
echo "⭐ Deleting a review:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "mutation { deleteReview(id: \"review-2\") }"
  }' \
  http://localhost:8081/graphql

echo
echo

# Test 36: Verify book ratings after review operations
echo "⭐ Verifying book ratings after review operations:"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query { bookById(id: \"book-1\") { id name averageRating reviewCount } }"
  }' \
  http://localhost:8081/graphql

echo
echo

echo "=== Demo completed ==="
echo
echo "💡 You can also access the interactive GraphiQL interface at:"
echo "   http://localhost:8081/graphiql"
echo
echo "🔐 Authentication:"
echo "   - Default user: 313@acu.com"
echo "   - Default password: 123456"
echo "   - Role: ADMIN (can perform all operations)"
echo
echo "📖 Available books:"
echo "   - book-1: The Lucky Country by Donald Horne"
echo "   - book-2: The Magic Pudding by Norman Lindsay (deleted in demo)"
echo
echo "🔄 Features demonstrated:"
echo "   - Authentication: JWT-based login"
echo "   - Authorization: Role-based access control"
echo "   - Field-Level Security: Hide sensitive fields based on user role"
echo "     * ADMIN users: Can see book reviews"
echo "     * Non-admin users: Reviews field is hidden (returns null)"
echo "   - Field Selection: Request only needed fields (name, genre, author)"
echo "   - bookById: Query individual books with field selection"
echo "   - books: Paginated book queries with cursor-based pagination"
echo "   - books: Search filtering by book name"
echo "   - books: Genre filtering"
echo "   - books: Combined search and genre filtering"
echo "   - books: Sorting by name, page count, and genre"
echo "   - books: Combined filtering and sorting"
echo "   - genres: Query all genres"
echo "   - genreById: Query individual genres with their books"
echo "   - booksByGenre: Query books by specific genre"
echo "   - Many-to-Many: Books can have multiple genres"
echo "   - createAuthor: Add new authors (ADMIN only)"
echo "   - createBook: Add new books (ADMIN only)"
echo "   - createGenre: Add new genres (ADMIN only)"
echo "   - updateBook: Modify existing books (ADMIN only)"
echo "   - updateGenre: Modify existing genres (ADMIN only)"
echo "   - deleteBook: Remove books (ADMIN only)"
echo "   - deleteGenre: Remove genres (ADMIN only)"
echo "   - addGenreToBook: Add genre to book (ADMIN only)"
echo "   - removeGenreFromBook: Remove genre from book (ADMIN only)"
echo "   - reviewsByBook: Query reviews for a specific book"
echo "   - reviewsByUser: Query reviews by a specific user"
echo "   - reviewById: Query individual reviews"
echo "   - createReview: Add new reviews (authenticated users)"
echo "   - updateReview: Modify existing reviews (owner only)"
echo "   - deleteReview: Remove reviews (owner only)"
echo "   - One-to-Many: Books can have multiple reviews"
echo "   - Rating System: 1-5 star ratings with comments"
echo "   - Average Ratings: Automatic calculation of book ratings"
