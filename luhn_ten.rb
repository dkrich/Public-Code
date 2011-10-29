#!/usr/bin/env ruby

str = "initialized"
record_array = Array.new
args = Array.new
account_balances = Hash.new
account_limits = Hash.new
account_counter = 0

# If a file name is specified on the command line, open it and traverse it.
if !ARGV[0].nil?
    print "\n"
    filename = ARGV[0]
    file = File.new(filename, "r")
    print "===================\nFile Contents:\n\n"
    while (str = file.gets)
       str.chomp!
       print str + "\n"
       args = str.split(" ")
       record_array << args
    end
    print "===================\n"
    file.close
# Otherwise, we'll wait for the data to be entered line-by-line.
else
    # While there is still command line input to read, take it in and split it on the white spaces, and append
    # it to the entire record array.
    while !str.empty?
     str = STDIN.gets
     str.chomp!
     args = str.split(" ")
     record_array << args
    end
end

print "Output:\n\n"

# This method is called to determine the validity of the credit card number at the time the number is added.
def cc_valid?(cc)
 total = 0
 counter = 0
 if cc.length > 0
   (cc.length - 1).downto(0) { |n|
     # If the current digit is in an odd index
     if (counter % 2) != 0
       # Here I chose to use a case statement to determine how to increment the LUHN count.
       # This could have been implemented in other ways, but I chose to use the case statement
       # because there are exactly 5 scenarios in which you would do something other than simply
       # add the doubled digit itself, and I figured that it was simpler and more efficient to just add
       # the values based on the case than to repeatedly split the digits and then add them together.
       case cc[n].to_i
       when 5
         total = total + 1
       when 6
         total = total + 3
       when 7
         total = total + 5
       when 8
         total = total + 7
       when 9
         total = total + 9
       else
         # If the current digit is 0-4, then the doubled value will be one digit. Knowing that,
         # we can just add the doubled value.
         total = total + (cc[n].to_i*2)
       end
     else
       # If the current digit is in an even index then just add that digit to the running total.
       total = total + cc[n].to_i
     end
     counter = counter + 1;
   }
 end
 # If the total mod 10 is equal to 0, the number is valid, otherwise it isn't.
 if total % 10 == 0
   return true
 else
   return false
 end
end

if !ARGV[0].nil?
   array_length = record_array.length-1
else
   array_length = record_array.length-2
end

for i in (0..array_length)
 command = record_array[i][0]
 name = record_array[i][1]
 
 case command.downcase
   when "add"
     # cc represents the entered credit card number.
     if !record_array[i][2].nil? and !record_array[i][3].nil?
       if record_array[i][2].to_i.is_a? Numeric
         cc = record_array[i][2].to_s
       else
         cc = "1"
         name = "No User"
       end
     else
       cc = "1"
       name = "No User"
     end
     # If the number is valid...
     if cc_valid?(cc)
       # ...then store the account limit and initialize the balance to $0.
       amount = record_array[i][3]
       account_balances[name] = 0
       account_limit = amount
       account_limit = account_limit[1..account_limit.length]
       account_limits[name] = account_limit
     else
       # ...otherwise, store "error" for the account balance.
       account_balances[name] = "error"
       account_limits[name] = "invalid"
     end
   when "charge"
     # If there is a valid number associated with the user...
     if !(account_limits[name] == "invalid") and !account_limits[name].nil?
       # ...then check to see whether the charge would put the balance over the limit...
       user_limit = account_limits[name]
       current_balance = account_balances[name]
       charge_amount = record_array[i][2]
       charge_amount = charge_amount[1..charge_amount.length]
       if user_limit.to_i > charge_amount.to_i + current_balance
         # ...and if not, update the balance.
         account_balances[name] = current_balance.to_i + charge_amount.to_i
       end
     end
   when "credit"
     # If there is a valid number associated with the user...
     if !(account_limits[name] == "invalid") and !account_limits[name].nil?
       # ...then go ahead and reduce the balance.
       current_balance = account_balances[name]
       credit_amount = record_array[i][2]
       credit_amount = credit_amount[1..credit_amount.length]
       account_balances[name] = current_balance.to_i - credit_amount.to_i
     end
   end
end

# Sort and print the results.
Hash[account_balances.sort].each { |key, value|
  if value != "error"
    print "#{key}: $#{value}\n"
  else
    print "#{key}: #{value}\n"
  end
}
print "===================\n"

exit!
