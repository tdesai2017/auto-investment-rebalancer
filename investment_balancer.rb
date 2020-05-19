"Add hello at top"
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

}

#Provide in percentages
desired_investment_percentages = {

  VTI: 44,
  VEA: 13,
  VWO: 13,
  QQQ: 15,
  DGRW: 9,
  BNDX: 6,
}

additional_invesments = 1000


balanced_investment_calculator(current_investment_division, desired_investment_percentages, additional_invesments)


"""

Non-taxable Accounts (401k, IRA)

Stocks (77% total )
QQQ —> Domestic tech stocks = 15%  (ER: 0.2)
VTI —> Domestic stocks (all)  = 38% (ER: 0.03) 
VEA —> Foreign Developed Markets = 12% (ER: 0.05)
VWO —> Foreign Emerging Markets = 12% (ER: 0.1)

 
Bonds (15% total) 
DGRW —> Wisdom Tree Dividend Growth fund (all) —> 60 = 9% (ER: 0.28)
BNDX —> International Bonds (all) —> 40  = 6% (ER: 0.08)

Real Estate (8% total)
VNQ —> Real-estate = 8% (ER: 0.12)

Taxable (Taxable Brokerage)

85% total 
QQQ —> Domestic tech stocks = 15%  (ER: 0.2)
VTI —> Domestic stocks (all)  = 44% (ER: 0.03) 
VEA —> Foreign Developed Markets = 13% (ER: 0.05)
VWO —> Foreign Emerging Markets = 13% (ER: 0.1)

 
15% total 
DGRW —> Wisdom Tree Dividend Growth fund (all) —> 60 = 9% (ER: 0.28)
BNDX —> International Bonds (all) 
https://www.portfoliovisualizer.com/backtest-portfolio#analysisResults

- Would switch to VMATX but it is too expense (minimum payment of 3000)


"""
