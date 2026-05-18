


find / -type f \( \
  -name "*.db" -o \
  -name "*.sqlite" -o \
  -name "*.sqlite3" -o \
  -name "*.sql" -o \
  -name "*.sql.gz" -o \
  -name "*.sql.bz2" -o \
  -name "*.dump" -o \
  -name "*.ibd" -o \
  -name "*.frm" -o \
  -name "*.mdb" -o \
  -name "*.accdb" \
\) 2>/dev/null 
