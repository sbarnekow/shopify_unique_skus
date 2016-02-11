require 'csv'

def find_duplicate_skus(file_name, include_gear)
  products = []
  skus = []

  products_with_dupe_skus = []

  CSV.foreach(file_name, headers: true) do |row|
    products.push(row)
      if include_gear
        unless row["Variant SKU"].nil? || row["Variant SKU"] == ""
         skus.push(row["Variant SKU"])
        end
      else
        unless row["Variant SKU"].nil? || row["Variant SKU"] == "" || row["Variant SKU"].upcase.include?("GEAR")
          skus.push(row["Variant SKU"])
        end
    end
  end

  duplicate_skus =  skus.find_all{ |sku| skus.count(sku) > 1 }
  unique_dupes = duplicate_skus.uniq.sort!

  unique_dupes.each do |sku|
    products.each do |product|
      if product["Variant SKU"] == sku
        products_with_dupe_skus.push(product)
      end
    end
  end

  CSV.open("products_with_dupe_skus-#{file_name}", "wb") do |csv|
    products_with_dupe_skus.each do |product|
      csv << product
    end
  end
end

def find_active_products_missing_barcodes(file_name)
  products = []

  CSV.foreach(file_name, headers:true) do |row|
    if row["Published"] == "true"
        products.push(row)
    end
  end

  CSV.open("active_products_missing_barcodes-#{file_name}", "wb") do |csv|
    products.each do |product|
      csv << product
    end
  end

end

find_active_products_missing_barcodes("products_export\ 6.csv")

include_gear = true
find_duplicate_skus("products_export\ 6.csv", include_gear)
