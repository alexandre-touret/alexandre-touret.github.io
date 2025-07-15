workspace "Name" "EcoTravel " {

    # Value / Goals:
    # - Give incentive for local eco-conscious tourism
    # - Traveller incentive: attract with lower costs
    # - Provider incentive: offer broad distribution at low incentive payments (close to direct booking)
    # 
    # Constraints
    # - Goals and values require that travel services & API with high incentive payments to the intermediary is avoided
    # 

    !identifiers hierarchical

    model {
        traveller = person "Traveller"
        association = person "Asso / Initiative"
        semiAutomatedProvider = person "Small / Local Provider"
        
        fullyAutomatedprovider = softwareSystem "Travel Provider"
        
        iotDevice = softwareSystem "IOT Carbon Monitor"
        group "Eco Travel Platform" {
            
            travelPlatform = softwareSystem "Traveller Portal" {
                webApp = container "Web App"
                mobileApp = container "Mobile app"
                customerProfiles = container "Customer Profile" {
                    tags "Database"
                }
                pastTravel = container "Past Travel Data" {
                    tags "Database"
                }
                

                webApp -> customerProfiles "Uses"
                webApp -> pastTravel "Uses"
                mobileApp -> customerProfiles "Uses"
                mobileApp -> pastTravel "Uses"
            }
            
            travelProducts = softwareSystem "Travel Reservation System" {
                shopping = container "Shop for product"
                booking = container "Book Products"
                donnation = container "Donnation"
                products = container "Travel Products" {
                    tags "Database"
                }
                reservation = container "Travel Reservation" {
                    tags "Database"
                }
                payment = container "PSP Integration"
                
                productConsumption = container "Product Consumption"
                shopping -> products "Search / Compare"
                booking -> products "Sells"
                booking -> payment "Process Payment"
                booking -> reservation "Creates"
                
            }

            providerPortal = softwareSystem "Provider Portal" {
                webApp = container "WebApp"
            }
            
            observability = softwareSystem "Status Portal" {
                technical = container "Application Status"
                business = container "Business Status"
            }
            
            
            providerPortal.webApp -> travelProducts.products "Control"
            travelPlatform.webApp -> travelProducts.shopping "Shopping"
            travelPlatform.webApp -> travelProducts.booking "Booking"
            travelPlatform.webApp -> travelProducts.reservation "Reservation"
            travelPlatform.mobileApp -> travelProducts.shopping "Shopping"
            travelPlatform.mobileApp -> travelProducts.booking "Booking"
            travelPlatform.mobileApp -> travelProducts.reservation "Reservation"
            
            travelProducts.reservation -> travelPlatform.pastTravel ""
            
            observability.business -> travelPlatform.pastTravel "aggregate usage / consumption" 
            observability.business -> travelProducts.productConsumption "report on products / partners" 
            observability.business -> travelProducts.reservation "report on ongoing travel consumption"
            
            travelPlatform -> observability.technical "report status"
            travelProducts -> observability.technical "report status"
            providerPortal -> observability.technical "report status"
        }       
        traveller -> travelPlatform.webApp "Uses"
        traveller -> travelplatform.mobileApp "Uses"
        semiAutomatedProvider -> travelProducts.products "Sells Products"
        fullyAutomatedProvider -> travelProducts.products "Sells Products"
        
        semiAutomatedProvider -> travelProducts.productConsumption "manual report"
        iotDevice -> travelProducts.productConsumption "reports"
        semiAutomatedProvider -> providerPortal "Creates Products"   
        association -> providerPortal "Creates Products"
    }


}