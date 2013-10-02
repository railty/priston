class Order < ActiveRecord::Base
  self.table_name = "ViewPOs"
  self.primary_key = "PO_ID"

  # attr_accessible :title, :body

  def signature_to_file(signature_type='')
    return if !['Ordered', 'Received', 'Approved', ''].include?(signature_type)
    sig = "Signature"
    sig = "#{signature_type}_Signature" if signature_type != ''
    f = File.open("tmp/#{self.PO_ID}.bmp", 'wb')
    f.write(self.send("#{sig}"))
    f.close
  end

  def delete_signature(signature_type='')
    return if !['Ordered', 'Received', 'Approved', ''].include?(signature_type)    
    sig = "Signature"
    sig = "#{signature_type}_Signature" if signature_type != ''
    self.send("#{sig}=", nil)
    self.save
  end

  def self.clean_signature
    ['Ordered_', 'Received_', 'Approved_', ''].each do |sig_type|
      orders = self.where("DataLength(#{sig_type}Signature)>10000")
      orders.each do |order|
        puts order.Invoice
        order.delete_signature
        #order.signature_to_file
      end
    end
  end
end
