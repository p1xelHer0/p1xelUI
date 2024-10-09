function(self, unitId, unitFrame, envTable)
    -- Target/Normal borders
    envTable.targetColor = "white"
    envTable.noTargetColor = "black"
    envTable.focusColor = "red"
    envTable.ruptureColor = "blue"
    envTable.borderThickness = 0.5
    
    -- focus border options
    local borderSize = 1.5
    local borderColor = "#ff0000"
    
    -- Setup border
    -- Healthbar border
    if (not unitFrame.healthBar.TargetBorder) then
        unitFrame.healthBar.TargetBorder = CreateFrame ("frame", nil, unitFrame.healthBar, "NamePlateFullBorderTemplate")
    end
    
    -- Castbar border
    if (not unitFrame.castBar.CastBarBorder) then
        unitFrame.castBar.CastBarBorder = CreateFrame("frame", nil, unitFrame.castBar, "NamePlateFullBorderTemplate")
    end
    
    -- Castbar icon border
    if (not unitFrame.castBar.IconOverlayFrame) then
        unitFrame.castBar.IconOverlayFrame = CreateFrame ("frame", nil, unitFrame.castBar)
        unitFrame.castBar.IconOverlayFrame:SetPoint ("topleft", unitFrame.castBar.Icon, "topleft")
        unitFrame.castBar.IconOverlayFrame:SetPoint ("bottomright", unitFrame.castBar.Icon, "bottomright")
        unitFrame.castBar.IconBorder = CreateFrame ("frame", nil,  unitFrame.castBar.IconOverlayFrame, "NamePlateFullBorderTemplate")
    end    
    
    -- Set border color depending on target
    function envTable.UpdateHealthBorder(unitFrame, unit)
        local profile = Plater.db.profile
        
        if profile.aggro_modifies.border_color then
            return
        end
        
        if (not unitFrame.IsSelf) then
            if (unitFrame.namePlateIsTarget) then
                Plater.SetBorderColor(self, envTable.targetColor)   
            elseif(UnitIsUnit ("focus", unit)) then
                Plater.SetBorderColor(self, envTable.targetColor)
            else
                Plater.SetBorderColor(self, envTable.noTargetColor)
            end
        end
    end
    
    function envTable.UpdateBorder(unitFrame)
        if (UnitIsUnit ("target", unitFrame.unit)) then               
            local r, g, b, a = DetailsFramework:ParseColors (targetColor)
            unitFrame.healthBar.TargetBorder:SetVertexColor (r, g, b, a)
            unitFrame.healthBar.TargetBorder:SetBorderSizes (borderSize, borderSize, borderSize, borderSize)
            unitFrame.healthBar.TargetBorder:UpdateSizes()            
            unitFrame.healthBar.TargetBorder:Show()
        else if (UnitIsUnit ("focus", unitFrame.unit)) then               
            local r, g, b, a = DetailsFramework:ParseColors (borderColor)
            unitFrame.healthBar.TargetBorder:SetVertexColor (r, g, b, a)                
            unitFrame.healthBar.TargetBorder:SetBorderSizes (borderSize, borderSize, borderSize, borderSize)
            unitFrame.healthBar.TargetBorder:UpdateSizes()            
            unitFrame.healthBar.TargetBorder:Show()
        else if (Plater.NameplateHasAura(unitFrame, "Rupture")) then
            local r, g, b, a = DetailsFramework:ParseColors (ruptureColor)
            unitFrame.healthBar.TargetBorder:SetVertexColor (r, g, b, a)
            unitFrame.healthBar.TargetBorder:SetBorderSizes (borderSize, borderSize, borderSize, borderSize)
            unitFrame.healthBar.TargetBorder:UpdateSizes()            
            unitFrame.healthBar.TargetBorder:Show()
        else
            unitFrame.healthBar.TargetBorder:Hide()
        end
    end
            
            -- Set Cast bar border
            function envTable.UpdateCastBarBorder(unitFrame)
                local castBar = unitFrame.castBar
                
                local size = envTable.borderThickness
                castBar.CastBarBorder:SetBorderSizes(size, size, size, size)
                castBar.CastBarBorder:UpdateSizes()
                
                local r, g, b, a = DetailsFramework:ParseColors(envTable.noTargetColor)
                castBar.CastBarBorder:SetVertexColor (r, g, b, a)
                
                castBar.CastBarBorder:Show()
            end
            
            -- Move and resize icon to the right
            function envTable.UpdateCastBarIcon(unitFrame)
                local castBar = unitFrame.castBar
                
                local icon = castBar.Icon
                
                castBar.BorderShield:Hide()
                
                icon:ClearAllPoints()
                icon:SetPoint("topright", castBar, "topleft", -4, 0)
                icon:SetHeight (22)
                icon:SetWidth (22)
                icon:Show()
            end
            
            function envTable.UpdateCastBarIconBorder(unitFrame)
                local castBar = unitFrame.castBar
                local icon = castBar.Icon
                
                local r, g, b, a = DetailsFramework:ParseColors(envTable.noTargetColor)
                castBar.IconBorder:SetVertexColor (r, g, b, a)
                
                local size = envTable.borderThickness
                castBar.IconBorder:SetBorderSizes (size, size, size, size)
                castBar.IconBorder:UpdateSizes()
                
                icon:Show()
                castBar.IconOverlayFrame:Show()
            end
        end

