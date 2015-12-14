require 'csv'

skus = []
CSV.foreach("products_export12_14.csv", headers: true) do |row|
  skus.push(row["Variant SKU"])
end

duplicate_skus = skus.find_all{ |sku| skus.count(sku) > 1 }
puts duplicate_skus
