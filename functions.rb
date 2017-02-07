class AccountInfo
  def set_up_initial_values
    @tally = 0.00
    @categories = {}
  end

  def update_tally(amount)
    @tally += amount
  end

  def add_category(category_name)
    @categories[category_name] = Category.new
    @categories[category_name].set_up_initial_values
  end

  def pretty_tally
    return @tally.round(2)
  end

  def already_has_category(category_name)
    return (@categories[category_name] != nil)
  end

  def category(category_name)
    return @categories[category_name]
  end

  def categories
    return @categories
  end
end

#does having a class this small make sense?  Seems more like a function, or a misplaced part
#of another class. tempted to put it in AccountInfo, but it doesn't fit too well...
class Flow
  def set_value(number_string_from_csv)
    @value = number_string_from_csv.gsub(/[,\$]/, "").to_f.round(2)
  end

  def to_f
    return @value
  end
end

class Category
  def set_up_initial_values
    @tally = 0.00
    @num_transactions = 0
    @average_transaction_cost = 0.00
  end

  def add_transaction(amount)
    @tally += amount
    @num_transactions += 1
    @average_transaction_cost = @tally / @num_transactions
  end

  def pretty_tally
    @tally.round(2).to_s.ljust(10)
  end

  def pretty_avg_transaction
    @average_transaction_cost.round(2).to_s.ljust(20)
  end
end


def build_accounts(string)

    accounts = {}


    CSV.foreach("accounts.csv", {headers: true, return_headers: false}) do |row|
      account = row["Account"].chomp

        if !accounts[account]
          accounts[account] = AccountInfo.new
          accounts[account].set_up_initial_values
        end

      current_account = accounts[account]
#
      outflow = Flow.new
      outflow.set_value(row["Outflow"])
      inflow = Flow.new
      inflow.set_value(row["Inflow"])

      transaction_amount = inflow.to_f - outflow.to_f
#
      current_account.update_tally(transaction_amount)

      category= row["Category"].chomp

      if !current_account.already_has_category(category)
        current_account.add_category(category)
      end

      current_account.category(category).add_transaction(transaction_amount)

    end

    if string != "Priya" && string != "Sonia"
      return @accounts = accounts
    else
      return @accounts = accounts.select{|k,v| k == string}
    end

end