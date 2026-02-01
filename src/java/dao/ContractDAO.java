package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Contract;

public class ContractDAO extends DBContext {

    public List<Contract> getAllContracts() {
        List<Contract> list = new ArrayList<>();
        String sql = "SELECT * FROM Contract";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Contract c = new Contract();
                c.setContractId(rs.getInt("contractId"));
                c.setStartDate(rs.getDate("startDate"));
                c.setEndDate(rs.getDate("endDate"));
                c.setStatus(rs.getInt("status"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void addContract(Contract c) {
        String sql = "INSERT INTO Contract (startDate, endDate, status) VALUES (?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setDate(1, new java.sql.Date(c.getStartDate().getTime()));
            st.setDate(2, new java.sql.Date(c.getEndDate().getTime()));
            st.setInt(3, c.getStatus());
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateContract(Contract c) {
        String sql = "UPDATE Contract SET startDate=?, endDate=?, status=? WHERE contractId=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setDate(1, new java.sql.Date(c.getStartDate().getTime()));
            st.setDate(2, new java.sql.Date(c.getEndDate().getTime()));
            st.setInt(3, c.getStatus());
            st.setInt(4, c.getContractId());
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Contract getContractById(int id) {
        String sql = "SELECT * FROM Contract WHERE contractId = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Contract(rs.getInt(1), rs.getDate(2), rs.getDate(3), rs.getInt(4), null, null);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}