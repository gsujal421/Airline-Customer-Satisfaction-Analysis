weight = float(input("Enter weight in Kg:"))
height = float(input("Enter height in M:"))

BMI=    (weight/(height*height ))
print(BMI)  
if (BMI<18):
    print ("Underweight")

elif(BMI<18.5):
    print("Thin for Height")


elif(18.6<= BMI <=24.9):
    print("Healthy Weight")



elif (25 <=BMI <=29.9):
    print("Overweight")


else:
    print("Obesity")
