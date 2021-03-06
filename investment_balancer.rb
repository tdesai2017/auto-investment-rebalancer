
require 'rspec/autorun'
class InvestmentBalancer

  public 

  #Computes balanced investment information and prints the data
  def self.balanced_investment_calculator(current_investment_division:, desired_investment_percentages:, additional_investments:)

    if desired_investment_percentages.values.sum != 100
      raise "Desired Percentages do not add to 100"
    end

    current_investments = current_investment_division.values.sum

    total_investments = additional_investments + current_investments

    new_distributions = NewDistributionCalculator.get_new_distributions(desired_investment_percentages: desired_investment_percentages, 
                                              current_investment_division: current_investment_division, 
                                              total_investments: total_investments)
                                              
      NewInvestmentDetailsPrinter.print_new_investment_report(current_investments: current_investments, 
                                additional_investments: additional_investments, 
                                total_investments: total_investments, 
                                new_distributions: new_distributions)
  end

  private

  
  class NewDistributionCalculator
    
    public
    #Calculates the new_distribution of investments required an organizes them into an array
    def self.get_new_distributions (desired_investment_percentages:, current_investment_division:, total_investments:)

      #Organizes Investments that WILL be in the new portfolio
      new_distributions = organize_investments_for_new_portfolio_info(desired_investment_percentages: desired_investment_percentages,
                                                                    current_investment_division: current_investment_division, 
                                                                    total_investments: total_investments)

      #Takes care of all securities that you are currently invested in but will not be invested in in the future
      new_distributions = organize_dropped_securities_info(new_distributions: new_distributions, 
                                                          current_investment_division: current_investment_division)

      new_distributions = structify_new_distributions(new_distributions: new_distributions)

      return new_distributions
    end

    private
    #Responsible for holding the investment information in order to hide data structure internals
    SecurityDetails = Struct.new(:current_investment, :balanced_investment, :required_change) 
      
    #Converts Array of information into a struct
    def self.structify_new_distributions(new_distributions:)
      new_distributions.each do |key, value|
        new_distributions[key] = SecurityDetails.new(value[0], value[1], value[2])
      end
      return (new_distributions)
    end


    #Organizes information regarding portfolios that will be in the updated portfolio 
    def self.organize_investments_for_new_portfolio_info(desired_investment_percentages:, current_investment_division:, total_investments:)
      new_distributions = {}
      desired_investment_percentages.each do |security, percentage|
        percentage = percentage.to_f
        new_amount_required = (total_investments * (percentage / 100)).round(2)
        current_amount_in_investment = current_investment_division.fetch(security, 0)
        change_in_investment = (new_amount_required - current_amount_in_investment).round(2)

        if change_in_investment >= 0
          change_in_investment = "+$#{change_in_investment}"
        else
          change_in_investment = "-$#{change_in_investment.abs()}"
        end
          
        new_distributions[security] = [current_amount_in_investment, new_amount_required, change_in_investment]
      end
      return new_distributions
    end

    #Organizes information regarding portfolios that will be dropped from the portfolio
    def self.organize_dropped_securities_info(new_distributions:, current_investment_division:)
      current_investment_division.each do |security, current_investment|
        #If you have a security you are currently invested in, but will not invest in the future, that means you will cash it all in
        if !new_distributions.key?(security)
          new_distributions[security] = [current_investment, 0, "-$#{current_investment} (AKA sell off)"]
        end
      end
      return new_distributions
    end

  end


  class NewInvestmentDetailsPrinter


    public
    #Prints out the entire investment report
    def self.print_new_investment_report (current_investments:, additional_investments:, total_investments:, new_distributions:)
      puts("")
      print_investment_totals(current_investments: current_investments, additional_investments: additional_investments, total_investments: total_investments)
      puts ("\n-------------------------------------\n\n")
      print_current_investments(new_distributions: new_distributions)
      puts ("\n-------------------------------------\n\n")
      print_balanced_investments(new_distributions: new_distributions)
      puts ("\n-------------------------------------\n\n")
      print_required_positive_changes(new_distributions: new_distributions)
      puts("")
      print_required_negative_changes(new_distributions: new_distributions)
    end


    private
    #Prints Totals for Current Investments, Aditional Funds, and New Total Investments
    def self.print_investment_totals(current_investments:, additional_investments:, total_investments:)
      puts ("Current Investments: $#{current_investments}        Additional Funds: $#{additional_investments}        New Total Investments: $#{total_investments} ")
    end

    #Prints current-investments portion of the report
    def self.print_current_investments(new_distributions:)
      puts("*Current Investments*")
      new_distributions.each do |security, values| 
        print ("#{security}: Current Invesment --> $#{values.current_investment}\n")
      end
    end

    #Prints balanced-investments portion of the report
    def self.print_balanced_investments(new_distributions:)
      puts("*Balanced Investments*")
      new_distributions.each do |security, values| 
        print ("#{security}: Balanced Investment --> $#{values.balanced_investment}\n")
      end
    end

    #Prints positive-change portion of the report
    def self.print_required_positive_changes(new_distributions:)
      puts("*Required Positive Changes*")
      new_distributions.each do |security, values| 
        if values[2].include?("+")
          print ("#{security}: Required changes --> #{values.required_change}\n")
        end
      end
    end

    #Prints required-negative-changes portion of the report
    def self.print_required_negative_changes(new_distributions:)
      puts("*Required Negative Changes*")
      new_distributions.each do |security, values| 
        if values[2].include?("-")
          print ("#{security}: Required changes --> #{values.required_change}\n")
        end
      end
    end
  end
end

################################################################################################################################

# Provide in dollars
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

additional_investments = 7445.69


InvestmentBalancer.balanced_investment_calculator(current_investment_division: current_investment_division,
                                                  desired_investment_percentages: desired_investment_percentages, 
                                                  additional_investments:  additional_investments)




describe InvestmentBalancer do
  it "overall very unsophisticated test" do 
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
    additional_investments = 7445.69  

    answer = "\nCurrent Investments: $7260.72        Additional Funds: $7445.69        New Total Investments: $14706.41 \n\n-------------------------------------\n\n*Current Investments*\nVTI: Current Invesment --> $0\nVXUS: Current Invesment --> $0\nQQQ: Current Invesment --> $2131.02\nBIV: Current Invesment --> $0\nBNDX: Current Invesment --> $0\nVGSIX: Current Invesment --> $0\nVCR: Current Invesment --> $2544.15\nVGT: Current Invesment --> $2585.55\n\n-------------------------------------\n\n*Balanced Investments*\nVTI: Balanced Investment --> $5926.68\nVXUS: Balanced Investment --> $3191.29\nQQQ: Balanced Investment --> $2205.96\nBIV: Balanced Investment --> $1323.58\nBNDX: Balanced Investment --> $882.38\nVGSIX: Balanced Investment --> $1176.51\nVCR: Balanced Investment --> $0\nVGT: Balanced Investment --> $0\n\n-------------------------------------\n\n*Required Positive Changes*\nVTI: Required changes --> +$5926.68\nVXUS: Required changes --> +$3191.29\nQQQ: Required changes --> +$74.94\nBIV: Required changes --> +$1323.58\nBNDX: Required changes --> +$882.38\nVGSIX: Required changes --> +$1176.51\n\n*Required Negative Changes*\nVCR: Required changes --> -$2544.15 (AKA sell off)\nVGT: Required changes --> -$2585.55 (AKA sell off)\n"

    expect { InvestmentBalancer.balanced_investment_calculator(current_investment_division: current_investment_division, 
                                                              desired_investment_percentages: desired_investment_percentages, 
                                                              additional_investments:  additional_investments) }.to output(answer).to_stdout
    
  end
end


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
