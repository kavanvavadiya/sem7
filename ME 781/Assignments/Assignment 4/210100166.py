import pandas as pd
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression as lr
from sklearn.linear_model import LinearRegression as lr
import statsmodels.api as sm

data = pd.read_csv("Olympic 100 m time.csv")
data['Year'] = pd.to_numeric(data['Year'], errors='coerce')
data['Olympic men\'s 100 m time (s)'] = pd.to_numeric(data['Olympic men\'s 100 m time (s)'], errors='coerce')
data['Olympic women\'s 100 m time (s)'] = pd.to_numeric(data['Olympic women\'s 100 m time (s)'], errors='coerce')

men_data = data[['Year', 'Olympic men\'s 100 m time (s)']].dropna()
women_data = data[['Year', 'Olympic women\'s 100 m time (s)']].dropna()

def regression_function(X, y, label):
    model = lr()
    model.fit(X, y)
    X_with_constant = sm.add_constant(X)
    model_sm = sm.OLS(y, X_with_constant).fit()
    coef = model.coef_[0]
    intercept = model.intercept_
    p_values = model_sm.pvalues
    conf_int = model_sm.conf_int(alpha=0.05)
    
    print(f"\n{label} Results:")
    print(f"Coefficient: {coef:.6f}")
    print(f"Intercept: {intercept:.6f}")
    print(f"P-values:\n{p_values}")
    print(f"95% Confidence Intervals:\n{conf_int}")
    
    return model, conf_int

men_model, men_conf_int =  regression_function(men_data[['Year']], men_data['Olympic men\'s 100 m time (s)'], "Men's")
women_model, women_conf_int =  regression_function(women_data[['Year']], women_data['Olympic women\'s 100 m time (s)'], "Women's")

plt.figure(figsize=(10, 8))

plt.scatter(men_data['Year'], men_data['Olympic men\'s 100 m time (s)'], color='green', label="Men's Data")
plt.plot(men_data['Year'], men_model.predict(men_data[['Year']]), color='green', linestyle='-', label="Men's Best Fit")
plt.plot(men_data['Year'], men_data['Year'] * men_conf_int.iloc[1, 0] + men_conf_int.iloc[0, 0], color='green', linestyle='--', label="Men's 95% Confidence Interval")
plt.plot(men_data['Year'], men_data['Year'] * men_conf_int.iloc[1, 1] + men_conf_int.iloc[0, 1], color='green', linestyle='--')

plt.scatter(women_data['Year'], women_data['Olympic women\'s 100 m time (s)'], color='red', label="Women's Data")
plt.plot(women_data['Year'], women_model.predict(women_data[['Year']]), color='red', linestyle='-', label="Women's Best Fit")
plt.plot(women_data['Year'], women_data['Year'] * women_conf_int.iloc[1, 0] + women_conf_int.iloc[0, 0], color='red', linestyle='--', label="Women's 95% Confidence Interval")
plt.plot(women_data['Year'], women_data['Year'] * women_conf_int.iloc[1, 1] + women_conf_int.iloc[0, 1], color='red', linestyle='--')

plt.xlabel('Year')
plt.ylabel('100m Time (s)')
plt.title('Men vs Women')
plt.legend()
plt.show()
