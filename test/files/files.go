package testfiles

import "embed"

//go:embed psql
var PostgresSchema embed.FS

//go:embed mysql
var MySQLSchema embed.FS

//go:embed sqlite
var SQLiteSchema embed.FS

//go:embed libsql/default
var LibSQLDefaultSchema embed.FS

//go:embed libsql/one
var LibSQLOneSchema embed.FS
