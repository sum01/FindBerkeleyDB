#include <db_cxx.h>
#include <cstdint>
#include <cstdlib>
#include <iostream>

template<typename T>
void err(const T &e) {
	std::cerr << e.what() << std::endl;
	std::exit(EXIT_FAILURE);
}

int main() {
	Db db(nullptr, 0);// Instantiate the Db object
	std::uint32_t oFlags = DB_CREATE;	// Open flags;
	try {
		// Open the database
		db.open(nullptr,// Transaction pointer
						"test_db.db",	// Database file name
						nullptr,// Optional logical database name
						DB_BTREE,	// Database access method
						oFlags,	// Open flags
						0);	// File mode (using defaults)
		// Close the database
		db.close(0);
		// DbException is not subclassed from std::exception, so
		// need to catch both of these.
	} catch (const DbException &e) {
		err(e);
	} catch (const std::exception &e) {
		err(e);
	}
	// No errors thrown, success
	std::exit(EXIT_SUCCESS);
}
