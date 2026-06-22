Admin.find_or_create_by!(email: "admin@anasol.com.br") do |a|
  a.password = "An@sol#Admin2026!"
end
