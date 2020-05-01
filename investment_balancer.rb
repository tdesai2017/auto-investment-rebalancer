def balanced_investment_calculator(current_investment_division, desired_investment_percentages, additional_invesments)

  if desired_investment_percentages.values.sum != 100
    raise "Desired Percentages do not add to 100"
  end


  current_investments = current_investment_division.values.sum
  # print(current_investments)


  total_invesments = additional_invesments + current_investments
  # print(total_invesments)

  #current amount, new amount required, change in invesment
  new_distributions = {}
  desired_investment_percentages.each do |security, percentage|
    percentage = percentage.to_f
    new_amount_required = (total_invesments * (percentage / 100)).round(2)
    current_amount_in_investment = current_investment_division.fetch(security, 0)
    change_in_investment = (new_amount_required - current_amount_in_investment).round(2)

    if change_in_investment >= 0
      change_in_investment = "+$#{change_in_investment}"
    else
      change_in_investment = "-$#{change_in_investment.abs()}"
    end
      
    new_distributions[security] = [current_amount_in_investment, new_amount_required, change_in_investment]
    
  end


  #Takes care of all securities that you are currently invested in but will not be invested in in the future
  current_investment_division.each do |security, current_investment|
    #If you have a security you are currently invested in, but will not invest in the future, that means you will cash it all in
    if !new_distributions.key?(security)
      new_distributions[security] = [current_investment, 0, "-$#{current_investment} (AKA sell off)"]
    end
  end



  puts ("Current Investments: $#{current_investments}        Additional Funds: $#{additional_invesments}        New Total Investments: $#{total_invesments} ")

  puts ("\n-------------------------------------\n\n")


  puts("*Current Investments*")
  new_distributions.each do |security, values| 

    print ("#{security}: Current Invesment --> $#{values[0]}\n")

  end

  puts ("\n-------------------------------------\n\n")

  puts("*Balanced Investments*")
  new_distributions.each do |security, values| 

    print ("#{security}: Balanced Investment --> $#{values[1]}\n")

  end
  
  puts ("\n-------------------------------------\n\n")


  puts("*Required Positive Changes*")
  new_distributions.each do |security, values| 

    if values[2].include?("+")
      print ("#{security}: Required changes --> #{values[2]}\n")
    end
  end

  puts("")

  puts("*Required Negative Changes*")
  new_distributions.each do |security, values| 

    if values[2].include?("-")
      print ("#{security}: Required changes --> #{values[2]}\n")
    end
  end


end

################################################################################################################################

#Provide in dollars
current_investment_division = 
{
QQQ: 2131.02,
VCR: 2544.15,
VGT: 2585.55,

}

#Provide in percentages
desired_investment_percentages = {

  VTI: 40.3,
  VXUS: 21.7,
  QQQ: 15,
  BIV: 9,
  BNDX: 6,
  VGSIX: 8
}

additional_invesments = 7445.69


balanced_investment_calculator(current_investment_division, desired_investment_percentages, additional_invesments)


