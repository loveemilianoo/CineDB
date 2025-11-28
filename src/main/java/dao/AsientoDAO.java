package dao;

import conexion.Conexion;
import entity.Asiento;
import entity.Sala;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AsientoDAO {
    
    public List<Asiento> getAsientos() {
        Conexion conn = new Conexion();
        Connection conexion = null;
        List<Asiento> asientos = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT * FROM tablas.asiento ORDER BY id_asiento ASC";
            ps = conexion.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Asiento asiento = new Asiento(
                    rs.getInt("id_asiento"),
                    rs.getString("fila").charAt(0), 
                    rs.getInt("numero_asiento"),
                    rs.getInt("id_sala")
                );
                asientos.add(asiento);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return asientos;
    }
    
    public List<Asiento> getAsientosPorSala(int idSala) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        List<Asiento> asientos = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT * FROM tablas.asiento WHERE id_sala = ? ORDER BY fila, numero_asiento ASC";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, idSala);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Asiento asiento = new Asiento(
                    rs.getInt("id_asiento"),
                    rs.getString("fila").charAt(0),
                    rs.getInt("numero_asiento"),
                    rs.getInt("id_sala")
                );
                asientos.add(asiento);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return asientos;
    }
    
    public Asiento getAsientoPorId(int idAsiento) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        Asiento asiento = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT * FROM tablas.asiento WHERE id_asiento = ?";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, idAsiento);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                asiento = new Asiento(
                    rs.getInt("id_asiento"),
                    rs.getString("fila").charAt(0),
                    rs.getInt("numero_asiento"),
                    rs.getInt("id_sala")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return asiento;
    }
    
    public void insertarAsiento(Asiento asiento) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "INSERT INTO tablas.asiento (fila, numero_asiento, id_sala) VALUES (?, ?, ?)";
            ps = conexion.prepareStatement(query);
            ps.setString(1, String.valueOf(asiento.getFila())); 
            ps.setInt(2, asiento.getNumeroAsiento());
            ps.setInt(3, asiento.getIdSala());
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
    }
    
    public void actualizarAsiento(Asiento asiento) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "UPDATE tablas.asiento SET fila = ?, numero_asiento = ?, id_sala = ? WHERE id_asiento = ?";
            ps = conexion.prepareStatement(query);
            ps.setString(1, String.valueOf(asiento.getFila()));
            ps.setInt(2, asiento.getNumeroAsiento());
            ps.setInt(3, asiento.getIdSala());
            ps.setInt(4, asiento.getIdAsiento());
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
    }
    
    public void eliminarAsiento(int idAsiento) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        
        try {
            conexion = conn.getConexion();
            String query = "DELETE FROM tablas.asiento WHERE id_asiento = ?";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, idAsiento);
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
    }
    
    // Verificacion si esta ocupado
    public void estaAsientoOcupado(int idAsiento, int idFuncion) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            String query = "SELECT COUNT(*) FROM tablas.boleto WHERE id_asiento = ? AND id_funcion = ?";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, idAsiento);
            ps.setInt(2, idFuncion);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
    }
    
    // Método adicional: obtener asientos disponibles por función
    public List<Asiento> getAsientosDisponiblesPorFuncion(int idFuncion, int idSala) {
        Conexion conn = new Conexion();
        Connection conexion = null;
        List<Asiento> asientosDisponibles = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conexion = conn.getConexion();
            // Asientos de la sala que NO están en boletos para esta función
            String query = "SELECT a.* FROM tablas.asiento a " +
                          "WHERE a.id_sala = ? AND a.id_asiento NOT IN " +
                          "(SELECT b.id_asiento FROM tablas.boleto b WHERE b.id_funcion = ?) " +
                          "ORDER BY a.fila, a.numero_asiento";
            ps = conexion.prepareStatement(query);
            ps.setInt(1, idSala);
            ps.setInt(2, idFuncion);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Asiento asiento = new Asiento(
                    rs.getInt("id_asiento"),
                    rs.getString("fila").charAt(0),
                    rs.getInt("numero_asiento"),
                    rs.getInt("id_sala")
                );
                asientosDisponibles.add(asiento);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error " + e.toString());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return asientosDisponibles;
    }
}