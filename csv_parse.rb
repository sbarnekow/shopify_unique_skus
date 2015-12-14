require 'csv'

def find_duplicate_skus(file_name)
  products = []
  skus = []

  products_with_dupe_skus_include_nil = []

  CSV.foreach(file_name, headers: true) do |row|
    products.push(row)
    unless row["Variant SKU"].nil? || row["Variant SKU"] == ""
      skus.push(row["Variant SKU"])
    end
  end

  duplicate_skus =  skus.find_all{ |sku| skus.count(sku) > 1 }
  unique_dupes = duplicate_skus.uniq.sort!

  unique_dupes.each do |sku|
    products.each do |product|
      if product["Variant SKU"] == sku
        products_with_dupe_skus_include_nil.push(product)
      end
    end
  end

  CSV.open("products_with_dupe_skus.csv", "wb") do |csv|
    products_with_dupe_skus_include_nil.each do |product|
      csv << product
    end
  end
end

def find_duplicate_skus_sans_gear(file_name)
  products = []
  skus = []

  products_with_dupe_skus_include_nil = []

  CSV.foreach(file_name, headers: true) do |row|
    products.push(row)
    unless row["Variant SKU"].nil? || row["Variant SKU"] == "" || row["Variant SKU"].upcase.include?("GEAR")
      skus.push(row["Variant SKU"])
    end
  end

  duplicate_skus =  skus.find_all{ |sku| skus.count(sku) > 1 }
  unique_dupes = duplicate_skus.uniq.sort!

  unique_dupes.each do |sku|
    products.each do |product|
      if product["Variant SKU"] == sku
        products_with_dupe_skus_include_nil.push(product)
      end
    end
  end

  CSV.open("products_with_dupe_skus_sans_gear.csv", "wb") do |csv|
    products_with_dupe_skus_include_nil.each do |product|
      csv << product
    end
  end
end


def find_nil_skus(file_name)
  nil_skus = []
  CSV.foreach(file_name, headers: true) do |row|
    if row["Variant SKU"].nil? || row["Variant SKU"] == ""
      nil_skus.push(row)
    end
  end
  CSV.open("products_with_nil_skus.csv", "wb") do |csv|
    nil_skus.each do |product|
      csv << product
    end
  end
end

find_duplicate_skus("products_export12_14.csv")
find_duplicate_skus_sans_gear("products_export12_14.csv")
# find_nil_skus("products_export12_14.csv")
