include("GreatPeoplePopup");

-- We removed the Great Diplomat of Austria form the UI
local BASE_PopulateData = PopulateData;

function PopulateData(data, isPast)
    if BASE_PopulateData ~= nil then
        BASE_PopulateData(data, isPast);
    end

    if data == nil or data.Timeline == nil then
        return;
    end

    local hiddenDiplomatClass = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_AUSTRIAN_DIPLOMAT"];
    if hiddenDiplomatClass == nil then
        return;
    end

    for i = #data.Timeline, 1, -1 do
        local person = data.Timeline[i];
        if person ~= nil and person.ClassID == hiddenDiplomatClass.Index then
            table.remove(data.Timeline, i);
        end
    end
end
