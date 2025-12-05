package dao;

import conexion.Conexion;
import java.util.*;
import entity.*;
import java.sql.*;

public class BoletoDAO {
    public List<Boleto> getBoletosPorUsuario(int idUsuario) {
        List<Boleto> boletos = new ArrayList<>();
        Connection conn = null;
        ResultSet rs = null;
        PreparedStatement ps = null;
        
        
        try {
            Conexion conexion = new Conexion();
            conn = conexion.getConexion();
            
            String query = "SELECT * FROM tablas.boleto WHERE id_usuario = ? ORDER BY fecha_compra DESC";
            
            ps = conn.prepareStatement(query);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Boleto boleto = new Boleto();
                boleto.setIdBoleto(rs.getInt("id_boleto"));
                boleto.setIdFuncion(rs.getInt("id_funcion"));
                boleto.setIdUsuario(rs.getInt("id_usuario"));
                boleto.setAsiento(rs.getString("asiento"));
                boleto.setPrecio(rs.getBigDecimal("precio"));
                
                Timestamp timestamp = rs.getTimestamp("fecha_compra");
                if (timestamp != null) {
                    boleto.setFechaCompra(timestamp.toLocalDateTime());
                }
                boleto.setEstado(rs.getString("estado"));
                boletos.add(boleto);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null)rs.close();
                if (ps != null)ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return boletos;
    }
}
